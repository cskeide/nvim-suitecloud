-- Development-only entry point. Not part of the plugin distribution.
vim.cmd([[set runtimepath+=.]])
require("suitecloud").setup()
