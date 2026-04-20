if vim.g.loaded_suitecloud then
	return
end
vim.g.loaded_suitecloud = true

require("suitecloud").setup()
