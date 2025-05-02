# nvim-suitecloud

A lightweight Neovim plugin to upload SuiteScript files to NetSuite using SuiteCloud CLI.

## ✨ Features
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

