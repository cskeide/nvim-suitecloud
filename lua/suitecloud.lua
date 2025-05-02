local M = {}

M.upload_current_file = function()
	local file_path = vim.fn.expand("%:p")
	local cmd = "suitecloud file:upload --paths " .. file_path

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

vim.api.nvim_create_user_command("SuiteUpload", M.upload_current_file, {})

return M
