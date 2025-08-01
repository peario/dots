if vim.loader then
  vim.loader.enable(true)
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
