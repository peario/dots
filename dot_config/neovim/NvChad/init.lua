vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

-- Map `<leader>` and `<localleader>`
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable some default providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Let Python be enabled for snippets
vim.g.loaded_python3_provider = 0

-- Load lazy.nvim
require("configs.lazy").load({
  -- profiling = {
  --   loader = false,
  --   require = false,
  -- }
  })

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
