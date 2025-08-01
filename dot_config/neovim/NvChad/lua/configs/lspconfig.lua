require("nvchad.configs.lspconfig").defaults()

local servers = {
  html = {},
  cssls = {},
  lua_ls = {},
}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)
  vim.lsp.config(name, opts)
end


