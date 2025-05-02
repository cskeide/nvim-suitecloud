# nvim-suitecloud

A lightweight Neovim plugin to upload SuiteScript files to NetSuite using SuiteCloud CLI.

## ✨ Features
- `:SuiteSetup` — Set up your NetSuite account using `suitecloud account:setup`
- `:SuiteDownload` — Download a file from NetSuite using `suitecloud file:import`
- `:SuiteUpload` — Upload current file to NetSuite using `suitecloud file:upload`

## 🚀 Installation
Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "cskeide/nvim-suitecloud",
  config = function()
    require("suitecloud")
  end,
}

