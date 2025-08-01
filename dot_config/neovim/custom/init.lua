vim.uv = vim.uv or vim.loop

if vim.loader then
  vim.loader.enable(true)
end

-- Bootstrap lazy.nvim, configs and plugins
require("config.lazy").load({
  -- debug = false,
  -- profiling = {
  --   loader = false,
  --   require = false,
  -- },
})
