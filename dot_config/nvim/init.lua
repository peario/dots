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
