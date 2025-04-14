-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- Disable perl provider as not installed or needed
vim.g.loaded_perl_provider = 0

-- LazyVim options
vim.g.snacks_animate = false

-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"

-- LSP Server to use for Rust.
-- Set to "bacon-ls" to use bacon-ls instead of rust-analyzer.
-- only for diagnostics. The rest of LSP support will still be
-- provided by rust-analyzer.
vim.g.lazyvim_rust_diagnostics = "bacon-ls"

-- @see: https://github.com/crisidev/bacon-ls?tab=readme-ov-file#neovim---manual
-- vim.diagnostic.config({
--   update_in_insert = true,
-- })

-- Indentation
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2

-- Searching
vim.opt.grepprg = "rg --vimgrep --smart-case --no-heading"

-- Language
vim.opt.spelllang = { "sv", "en_us" }

-- Other
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
vim.opt.mousescroll = "ver:2,hor:6"
vim.opt.cmdheight = 0

-- User powershell on windows
if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh")
end
