-- fallback to `vim.loop` if `vim.uv` is not available
vim.uv = vim.uv or vim.loop

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

if vim.loader then
	vim.loader.enable(true)
end

require("config.lazy").load()
