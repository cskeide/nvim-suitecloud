# nvim-suitecloud

A lightweight Neovim plugin to upload SuiteScript files to NetSuite using SuiteCloud CLI.

## ✨ Features
- `:SuiteSetup` — Set up your NetSuite account using `suitecloud account:setup`
- `:SuiteDownload` — Download a file from NetSuite using `suitecloud file:import`
- `:SuiteUpload` — Upload current file to NetSuite using `suitecloud file:upload`

##  �️ Prerequisites
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
    require("suitecloud")
  end,
}
```

## ⌨️ Default Keybindings
The following keybindings are available by default:

- `<leader>Na`: Run `:SuiteSetup` to set up your NetSuite account.
- `<leader>Ni`: Run `:SuiteDownload` to import files from NetSuite.
- `<leader>Nu`: Run `:SuiteUpload` to upload the current file to NetSuite.

## ℹ️ Disclaimer
This project has been developed for personal use. I cannot guarantee that it will work as expected in all environments or use cases. Use it at your own risk, and I assume no responsibility for any issues that may arise.

