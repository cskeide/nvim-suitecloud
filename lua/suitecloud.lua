local M = {}

local cached_project_root = nil
local cached_suitecloud_installed = nil
local dirchanged_autocmd_registered = false

local function find_project_root()
	if cached_project_root then
		return cached_project_root
	end
	local cwd = vim.fn.getcwd()
	while cwd ~= "/" do
		if vim.fn.filereadable(cwd .. "/suitecloud.config.js") == 1 then
			cached_project_root = cwd
			return cached_project_root
		end
		cwd = vim.fn.fnamemodify(cwd, ":h")
	end
	return nil
end

local function is_suitecloud_installed()
	if cached_suitecloud_installed ~= nil then
		return cached_suitecloud_installed
	end
	local result = vim.fn.systemlist("which suitecloud")
	cached_suitecloud_installed = result and #result > 0
	return cached_suitecloud_installed
end

local function run_suitecloud_command(cmd, notification, project_root)
	if not is_suitecloud_installed() then
		vim.notify("SuiteCloud CLI is not installed or not in PATH", vim.log.levels.ERROR)
		return
	end
	if not project_root then
		project_root = find_project_root()
	end
	if not project_root then
		vim.notify("Not in a SuiteCloud project root folder", vim.log.levels.ERROR)
		return
	end
	vim.notify(notification, vim.log.levels.INFO)

	local ok, snacks = pcall(require, "snacks")
	if not ok then
		vim.notify("snacks.nvim is required but not installed", vim.log.levels.ERROR)
		return
	end

	snacks.terminal.open(
		cmd,
		{
			cwd = project_root,
			start_insert = true,
			auto_close = false,
		}
	)
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
	local cmd = "suitecloud file:upload "
		.. vim.fn.shellescape(file_path)
		.. " --paths "
		.. vim.fn.shellescape("/" .. suitecloud_path)
	run_suitecloud_command(cmd, "Running SuiteCloud File Upload", project_root)
end

M.download_file = function()
	local cmd = "suitecloud file:import -i"
	run_suitecloud_command(cmd, "Running SuiteCloud File Import")
end

M.setup = function(opts)
	opts = opts or {}

	-- Invalidate the project root cache whenever Neovim changes directory.
	if not dirchanged_autocmd_registered then
		dirchanged_autocmd_registered = true
		vim.api.nvim_create_autocmd("DirChanged", {
			pattern = "*",
			callback = function()
				cached_project_root = nil
			end,
		})
	end

	vim.api.nvim_create_user_command("SuiteUpload", M.upload_current_file, {})
	vim.api.nvim_create_user_command("SuiteSetup", M.setup_account, {})
	vim.api.nvim_create_user_command("SuiteDownload", M.download_file, {})

	if opts.keymaps ~= false then
		local keymaps = type(opts.keymaps) == "table" and opts.keymaps or {}
		local setup_key = keymaps.setup or "<leader>Na"
		local upload_key = keymaps.upload or "<leader>Nu"
		local download_key = keymaps.download or "<leader>Ni"
		if type(setup_key) == "string" and setup_key ~= "" then
			vim.keymap.set("n", setup_key, ":SuiteSetup<CR>", { noremap = true, silent = true, desc = "SuiteCloud Account Setup" })
		end
		if type(upload_key) == "string" and upload_key ~= "" then
			vim.keymap.set("n", upload_key, ":SuiteUpload<CR>", { noremap = true, silent = true, desc = "SuiteCloud Upload" })
		end
		if type(download_key) == "string" and download_key ~= "" then
			vim.keymap.set("n", download_key, ":SuiteDownload<CR>", { noremap = true, silent = true, desc = "SuiteCloud Import" })
		end
	end
end

return M
