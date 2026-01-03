if vim.loader then vim.loader.enable(true) end

-- Disable unnecessary built-in plugins
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tutor = 1
vim.g.loaded_2to3 = 1
vim.g.loaded_indent_blankline = 1
vim.g.loaded_matchparen = 1 -- If you don't need paren highlighting
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_vimball = 1

-- Bootstrap mini.nvim and mini.deps
local minipath = vim.fn.stdpath("data") .. "pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(minipath) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/nvim-mini/mini.nvim", minipath }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("mini.deps").setup()
