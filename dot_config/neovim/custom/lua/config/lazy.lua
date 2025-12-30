-- Bootstrap lazy.nvim
local lazypath = vim.env.LAZY or vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazyversion = "--branch=stable"

if not (vim.env.LAZY or vim.uv.fs_stat(lazypath)) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		lazyversion, -- e.g. `--branch=stable`
		lazyrepo,
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim: \n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local M = {}

---@param opts? LazyConfig
function M.load(opts)
	-- Extend "default" opts with some user-customizable key-values
	-- See defaults and options at: https://lazy.folke.io/configuration
	opts = vim.tbl_deep_extend("force", {
		defaults = { lazy = true },
		---@type LazySpec
		spec = {
			{ import = "plugins" },
		},
		install = {
			missing = true,
			colorscheme = { "nord", "tokyonight", "habamax" },
		},
		diff = { cmd = "terminal_git" },
		checker = {
			enabled = true,
			notify = true,
		},
		change_detection = {
			enabled = true,
			notify = false,
		},
		performance = {
			rtp = {
				disabled_plugins = {
					"gzip",
					-- "matchit",
					-- "matchparen",
					-- "netrwPlugin",
					"tarPlugin",
					"zipPlugin",
					"tohtml",
					"tutor",
				},
			},
		},
		debug = false,
		profiling = {
			loader = false,
			require = false,
		},
	}, opts or {})

	-- Check that lazy.nvim is loadable
	local ok, lazy = pcall(require, "lazy")
	if not ok then
		vim.api.nvim_echo({
			{ "Could not load lazy.nvim from path:\n", "ErrorMsg" },
			{ lazypath, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end

	-- Setup lazy.nvim
	lazy.setup(opts)

	require("config.options")
	require("config.autocmds")

	vim.schedule(function()
		require("config.mappings")
	end)
end

return M
