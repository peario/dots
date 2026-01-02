---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  add({
    source = "stevearc/conform.nvim",
    depends = { "mason-org/mason.nvim" },
  })

  local conform = require("conform")

  conform.setup({
    default_format_opts = {
      lsp_format = "fallback", -- not recommended to change
    },
    format_on_save = {
      timeout_ms = 500,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
    },
    formatters = {
      ["markdown-toc"] = {
        condition = function(_, ctx)
          for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
            if line:find("<!%-%- toc %-%->") then return true end
          end
        end,
      },
      ["markdownlint-cli2"] = {
        condition = function(_, ctx)
          local diag = vim.tbl_filter(function(d) return d.source == "markdownlint" end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
    },
    formatters_by_ft = {
      bash = { "shellharden", "shfmt" },
      buf = { "buf" },
      css = { "rustywind", "prettier" },
      go = { "goimports", "golines", "gofumpt" },
      html = { "rustywind", "prettier" },
      javascript = { "rustywind", "prettier" },
      javascriptreact = { "rustywind", "prettier" },
      ["javascript.jsx"] = { "rustywind", "prettier" },
      json = { "fixjson", "prettier" },
      lua = { "stylua" },
      markdown = { "prettier", "cbfmt", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      sh = { "shfmt" },
      sql = { "sqruff" },
      toml = { "taplo" },
      typescript = { "rustywind", "prettier" },
      typescriptreact = { "rustywind", "prettier" },
      ["typescript.tsx"] = { "rustywind", "prettier" },
      yaml = { "yamlfmt" },
    },
  })
end)
