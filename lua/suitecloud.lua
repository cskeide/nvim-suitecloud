local M = {}

local function find_project_root()
	local cwd = vim.fn.getcwd()
	while cwd ~= '/' do
		if vim.fn.filereadable(cwd .. '/suitecloud.config.js') == 1 then
			return cwd
		end
		cwd = vim.fn.fnamemodify(cwd, ':h')
	end
	return nil
end

local function run_in_project_root(cmd)
	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
				vim.api.nvim_echo({ { table.concat(data, "\n"), "Normal" } }, false, {})
			end
		end,
		on_stderr = function(_, err_data)
			if err_data then
				vim.api.nvim_err_writeln(table.concat(err_data, "\n"))
			end
		end,
	})
end

M.upload_current_file = function()
	local file_path = vim.fn.expand("%:p")
	local cmd = "suitecloud file:upload --paths " .. file_path
	run_in_project_root(cmd)
end

M.setup_account = function()
	vim.cmd("split | terminal suitecloud account:setup")
end

M.download_file = function()
	local file_path = vim.fn.input("Enter the file path to download: ")
	local cmd = "suitecloud file:download --paths " .. file_path
	run_in_project_root(cmd)
end

vim.api.nvim_create_user_command("SuiteUpload", M.upload_current_file, {})
vim.api.nvim_create_user_command("SuiteSetup", M.setup_account, {})
vim.api.nvim_create_user_command("SuiteDownload", M.download_file, {})

return M
