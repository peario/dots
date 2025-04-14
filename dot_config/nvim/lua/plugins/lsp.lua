-- NOTE: While this file is called `lsp.lua` it's actually encompasses formatters, linters, etc. as well
-- Intended to install said tools as well.
return {
  {
    "mfussenegger/nvim-lint",
    event = { "LazyFile", "VeryLazy" },
  },
  -- Neovim as LSP
  {
    "nvimtools/none-ls.nvim",
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      -- Just to make sure "ts-node-action" is available
      -- It's required (not sure if direct or indirect) by `builtins.code_actions.ts_node_action`
      {
        "ckolkey/ts-node-action",
        dependencies = "nvim-treesitter",
        opts = {},
      },
      -- For those sources which uses "vim.ui.input" and "vim.ui.select"
      "folke/snacks.nvim",
    },
    opts = function(_, opts)
      local h = require("null-ls.helpers")
      local nls = require("null-ls")

      -- Inject tools via Neovim as LSP
      -- NOTE: Any linters, formatters, etc. needs to be installed.
      --  See if they exists in the mason registry and add them to `ensure_installed` in "WhoIsSethDaniel/mason-tool-installer.nvim"
      --  In the file `./lua/plugins/mason.lua`
      opts.sources = vim.list_extend(opts.sources or {}, {
        -- Code actions
        nls.builtins.code_actions.ts_node_action,
        -- Completion
        -- nls.builtins.completion.luasnip,
        nls.builtins.completion.nvim_snippets,
        -- Diagnostics / linters
        nls.builtins.diagnostics.actionlint,
        nls.builtins.diagnostics.buf,
        nls.builtins.diagnostics.commitlint.with({
          runtime_condition = h.cache.by_bufnr(function(params)
            local conf_file_names = { ".commitlintrc", "commitlint.config" }
            local conf_file_exts = { "js", "cjs", "mjs", "ts", "cts" }
            local conf_file_exts_extra = { "json", "yaml", "yml" }

            -- Array with all valid filenames and filetypes for commitlint
            local conf_files = { ".commitlintrc" }

            -- Insert those valid config filetypes and filenames into the array above
            for _, exts_extra in ipairs(conf_file_exts_extra) do
              table.insert(conf_files, ".commitlintrc." .. exts_extra)
            end
            for _, file in ipairs(conf_file_names) do
              for _, exts in ipairs(conf_file_exts) do
                table.insert(conf_files, file .. "." .. exts)
              end
            end

            -- Store first match of valid fileformats if found
            local config_file_paths = vim.fs.find(conf_files, {
              path = vim.fn.bufname(params.bufnr),
              upward = true,
              stop = vim.fs.dirname(params.root),
            })[1]

            -- If no config has been found, don't run
            return config_file_paths and true or false
          end),
        }),
        nls.builtins.diagnostics.dotenv_linter.with({
          runtime_condition = h.cache.by_bufnr(function(params)
            local buffer_name = vim.fn.bufname(params.bufnr)
            -- Include files containing ".env" but explicity exclude ".envrc"
            return buffer_name:find("%.env") ~= nil and not buffer_name:find("%.envrc$")
          end),
        }),
        nls.builtins.diagnostics.revive.with({
          -- Make sure that revive checks for config files in project and use if found
          args = h.cache.by_bufnr(function(params)
            local default_args = { "-formatter", "json", "./..." }

            -- If config file exists, use it
            local config_file_name = "revive.toml"
            local config_file_path = vim.fs.find(config_file_name, {
              path = vim.fn.bufname(params.bufnr),
              upward = true,
              stop = vim.fs.dirname(params.root),
            })[1]

            if config_file_path then
              default_args = vim.list_extend({ "-config", config_file_path }, default_args)
            end

            return default_args
          end),
        }),
        nls.builtins.diagnostics.sqruff.with({
          -- Make sure that sqruff checks for config files in project and use if found
          args = h.cache.by_bufnr(function(params)
            local default_args = { "lint", "-" }

            -- If config file exists, use it
            local config_file_name = ".sqruff"
            local config_file_path = vim.fs.find(config_file_name, {
              path = vim.fn.bufname(params.bufnr),
              upward = true,
              stop = vim.fs.dirname(params.root),
            })[1]

            if config_file_path then
              default_args = vim.list_extend({ "--config", config_file_path }, default_args)
            end

            return default_args
          end),
        }),
        nls.builtins.diagnostics.trivy.with({
          filetypes = {
            -- according to mason-registry
            -- @see: https://mason-registry.dev/registry/list?search=trivy
            "c",
            "cs",
            "cpp",
            "dart",
            "Dockerfile",
            "elixir",
            "go",
            "yaml",
            "java",
            "javascript",
            "php",
            "python",
            "ruby",
            "rust",
            "typescript",
            -- default according to none-ls.nvim
            -- @see: https://github.com/nvimtools/none-ls.nvim/blob/main/lua/null-ls/builtins/diagnostics/trivy.lua#L22
            "terraform",
            "tf",
            "terraform-vars",
          },
        }),
        nls.builtins.diagnostics.zsh,
        -- Formatting
        -- nls.builtins.formatting.asmfmt,
        nls.builtins.formatting.buf,
        nls.builtins.formatting.cbfmt,
        nls.builtins.formatting.clang_format,
        nls.builtins.formatting.golines,
        nls.builtins.formatting.leptosfmt,
        nls.builtins.formatting.rustywind,
        nls.builtins.formatting.shellharden,
        nls.builtins.formatting.stylelint,
        nls.builtins.formatting.sqruff.with({
          -- Make sure that sqruff checks for config files in project and use if found
          args = h.cache.by_bufnr(function(params)
            local default_args = { "fix", "-" }

            -- If config file exists, use it
            local config_file_name = ".sqruff"
            local config_file_path = vim.fs.find(config_file_name, {
              path = vim.fn.bufname(params.bufnr),
              upward = true,
              stop = vim.fs.dirname(params.root),
            })[1]

            if config_file_path then
              default_args = vim.list_extend({ "--config", config_file_path }, default_args)
            end

            return default_args
          end),
        }),
        nls.builtins.formatting.typstyle,
        -- Hover
        nls.builtins.hover.printenv,
      })
    end,
  },
  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "LazyFile", "VeryLazy" },
    opts = {
      inlay_hints = { enabled = true },
      ---@type lspconfig.options
      ---@diagnostic disable-next-line: missing-fields
      servers = {
        ---@diagnostic disable-next-line: missing-fields
        cssls = {
          filetypes_include = { "css", "scss", "less", "sass", "html", "vue", "svelte" },
        },
      },
    },
  },
}
