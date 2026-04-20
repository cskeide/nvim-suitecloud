# nvim-suitecloud

A lightweight Neovim plugin to upload SuiteScript files to NetSuite using SuiteCloud CLI.

## ✨ Features
- `:SuiteSetup` — Set up your NetSuite account using `suitecloud account:setup`
- `:SuiteDownload` — Download a file from NetSuite using `suitecloud file:import`
- `:SuiteUpload` — Upload current file to NetSuite using `suitecloud file:upload`

## 🛠️ Prerequisites
- [SuiteCloud CLI](https://www.npmjs.com/package/@oracle/suitecloud-cli) must be installed globally using npm:
  ```bash
  npm install -g @oracle/suitecloud-cli
  ```

## 🚀 Installation
Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "cskeide/nvim-suitecloud",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    require("suitecloud").setup()
  end,
}
```

The plugin is automatically set up with default options when loaded via the plugin runtime directory. Calling `setup()` explicitly in your config is only required if you want to customise options.

## ⚙️ Configuration

`setup()` accepts an optional table of options:

```lua
require("suitecloud").setup({
  -- Set keymaps = false to disable all default keybindings.
  -- Or provide a table of custom keys to override individual bindings.
  keymaps = {
    setup    = "<leader>Na",  -- :SuiteSetup
    upload   = "<leader>Nu",  -- :SuiteUpload
    download = "<leader>Ni",  -- :SuiteDownload
  },
})
```

To disable default keybindings entirely:

```lua
require("suitecloud").setup({ keymaps = false })
```

## ⌨️ Default Keybindings
The following keybindings are set up by default (pass `keymaps = false` to opt out):

- `<leader>Na`: Run `:SuiteSetup` to set up your NetSuite account.
- `<leader>Ni`: Run `:SuiteDownload` to import files from NetSuite.
- `<leader>Nu`: Run `:SuiteUpload` to upload the current file to NetSuite.

## ℹ️ Disclaimer
This project has been developed for personal use. I cannot guarantee that it will work as expected in all environments or use cases. Use it at your own risk, and I assume no responsibility for any issues that may arise.

