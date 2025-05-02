local M = {}

local cached_project_root = nil

local function find_project_root()
	if cached_project_root then
		return cached_project_root
	end
	local cwd = vim.fn.getcwd()
	while cwd ~= '/' do
		if vim.fn.filereadable(cwd .. '/suitecloud.config.js') == 1 then
			cached_project_root = cwd
			return cached_project_root
		end
		cwd = vim.fn.fnamemodify(cwd, ':h')
	end
	return nil
end

local function is_suitecloud_installed()
	local result = vim.fn.systemlist("which suitecloud")
	if result and #result > 0 then
		return true
	else
		return false
	end
end

local function run_suitecloud_command(cmd, notification)
	if not is_suitecloud_installed() then
		vim.notify("SuiteCloud CLI is not installed or not in PATH", vim.log.levels.ERROR)
		return
	end
	local project_root = find_project_root()
	if not project_root then
		vim.notify("Not in a SuiteCloud project root folder", vim.log.levels.ERROR)
		return
	end
	vim.notify(notification, vim.log.levels.INFO)

	local buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		row = row,
		col = col,
		style = 'minimal',
	})

	vim.fn.termopen(cmd, {
		cwd = project_root,
		on_exit = function()
			--vim.api.nvim_win_close(win, true)
		end,
	})
	vim.cmd("startinsert")
end

M.setup_account = function()
	run_suitecloud_command("suitecloud account:setup", "Running SuiteCloud Account Setup")
end

M.upload_current_file = function()
	local file_path = vim.fn.expand("%:p")
	local project_root = find_project_root()
	if not project_root then
		vim.notify("Not in a SuiteCloud project root folder", vim.log.levels.ERROR)
		return
	end
	local relative_path = file_path:sub(#project_root + 2) -- Get the path relative to the project root
	local suitecloud_path = relative_path:match("SuiteScripts/.*") -- Extract the path starting from SuiteScripts
	if not suitecloud_path then
		vim.notify("File is not within the SuiteScripts folder", vim.log.levels.ERROR)
		return
	end
	local cmd = "suitecloud file:upload '" .. file_path .. "' --paths '/" .. suitecloud_path .. "'"
	run_suitecloud_command(cmd, "Running SuiteCloud File Upload")
end

M.download_file = function()
	local cmd = "suitecloud file:import -i "
	run_suitecloud_command(cmd, "Running SuiteCloud File Import")
end

vim.api.nvim_create_user_command("SuiteUpload", M.upload_current_file, {})
vim.api.nvim_create_user_command("SuiteSetup", M.setup_account, {})
vim.api.nvim_create_user_command("SuiteDownload", M.download_file, {})

vim.api.nvim_set_keymap('n', '<leader>Ns', ':SuiteSetup<CR>', { noremap = true, silent = true, desc = 'SuiteCloud Setup' })
vim.api.nvim_set_keymap('n', '<leader>Nu', ':SuiteUpload<CR>', { noremap = true, silent = true, desc = 'SuiteCloud Upload' })
vim.api.nvim_set_keymap('n', '<leader>Ni', ':SuiteDownload<CR>', { noremap = true, silent = true, desc = 'SuiteCloud Import' })

return M
