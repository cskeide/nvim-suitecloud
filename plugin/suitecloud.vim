lua require('suitecloud')

vim.api.nvim_set_keymap('n', '<leader>Ns', ':SuiteSetup<CR>', { noremap = true, silent = true, desc = 'SuiteCloud Setup' })
vim.api.nvim_set_keymap('n', '<leader>Nu', ':SuiteUpload<CR>', { noremap = true, silent = true, desc = 'SuiteCloud Upload' })
vim.api.nvim_set_keymap('n', '<leader>Ni', ':SuiteDownload<CR>', { noremap = true, silent = true, desc = 'SuiteCloud Import' })

