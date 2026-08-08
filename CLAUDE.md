# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A small Neovim plugin that wraps the [SuiteCloud CLI](https://www.npmjs.com/package/@oracle/suitecloud-cli) to upload/import NetSuite SuiteScript files. Essentially all logic lives in `lua/suitecloud.lua` (~125 lines); there is no build step, no test suite, and no linter config.

## Commands

```bash
nvim -u init.lua          # dev entry point: adds cwd to runtimepath and calls setup()
```

`init.lua` is development-only and not part of the distribution — it exists so you can load the working copy without installing it. Real users get loaded via `plugin/suitecloud.lua`.

Runtime prerequisites: `suitecloud` on `PATH` (`npm install -g @oracle/suitecloud-cli`) and [snacks.nvim](https://github.com/folke/snacks.nvim), which is a hard dependency for the terminal UI.

## Architecture

- `plugin/suitecloud.lua` — runtime plugin file. Guards on `vim.g.loaded_suitecloud` and calls `require("suitecloud").setup()`, so **the plugin self-configures with defaults on load**. Users only call `setup()` themselves to override options.
- `lua/suitecloud.lua` — the module. `setup(opts)` registers the three user commands (`:SuiteSetup`, `:SuiteUpload`, `:SuiteDownload`), the default keymaps, and a `DirChanged` autocmd.
- `VERSION` — plain text tag (`v1.0.0`), updated by hand.

All three commands funnel through `run_suitecloud_command(cmd, notification, project_root)`, which checks the CLI is installed, resolves the project root, then opens the command in a `snacks.terminal` floating window with `auto_close = false`.

## Things to know before editing

- **Two module-level caches, one invalidation path.** `cached_project_root` is cleared only by the `DirChanged` autocmd registered in `setup()`; `cached_suitecloud_installed` is never invalidated for the session. Adding a new lookup means deciding how it gets refreshed — reloading the module in a running Neovim will not clear either.
- **`setup()` is idempotent-ish but not fully.** The `dirchanged_autocmd_registered` flag prevents duplicate autocmds across repeated calls, but user commands and keymaps are re-registered each time.
- **Project root detection walks up from `getcwd()`** looking for `suitecloud.config.js`, stopping at `/`. It is based on the working directory, not the current buffer's path.
- **Upload has a path constraint beyond the project root.** `upload_current_file` makes the file path relative to the root, then requires it to match `SuiteScripts/.*`; anything outside that folder is rejected. The CLI is invoked with both the absolute path and `--paths /<SuiteScripts-relative-path>`.
- **Keymap opt-out is `keymaps = false`**; passing a table overrides individual keys (`setup`/`upload`/`download`), and an empty-string value skips that one binding. Defaults are `<leader>Na`, `<leader>Nu`, `<leader>Ni`.
- Errors surface via `vim.notify(..., vim.log.levels.ERROR)` and return early — the module never raises.
- The file uses **tab indentation**; match it.
