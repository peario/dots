---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  -- While within (neo)vim, add mason binaries to PATH.
  vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

  vim.diagnostic.config({
    -- underline = { severity = { min = severity.HINT, max = severity.ERROR } },
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      prefix = "",
      source = "if_many",
      -- current_line = true,
      -- severity = { min = severity.ERROR, max = severity.ERROR },
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅙",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "󰋼",
        [vim.diagnostic.severity.HINT] = "󰌵",
      },
      -- severity = {
      --   min = vim.diagnostic.severity.WARN,
      --   max = vim.diagnostic.severity.ERROR,
      -- },
      -- priority = 9999,
    },
  })

  -- Enable inlay hints
  vim.lsp.inlay_hint.enable(true, {})

  -- Mason:
  --   Package manager for neovim
  add({
    source = "mason-org/mason.nvim",
    depends = { "nvim-lua/plenary.nvim" },
  })

  -- nvim-lspconfig:
  --   Quickstart configs for Neovim LSP
  -- Deps:
  --   - mason.nvim for installing tools, lsp, formatters, linters and daps
  --   - mason-lspconfig.nivm extension to mason.nvim for better integration with nvim-lspconfig
  add({
    source = "neovim/nvim-lspconfig",
    depends = { "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim" },
  })

  -- mason-nvim-dap.nvim:
  --  Extension to mason.nvim to better integrate nvim-dap
  add({
    source = "jay-babu/mason-nvim-dap.nvim",
    depends = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
  })

  require("mason").setup({
    ui = {
      icons = {
        package_pending = " ",
        package_installed = " ",
        package_uninstalled = " ",
      },
    },
    max_concurrent_installers = 10,
  })

  vim.keymap.set("n", "<leader>M", "<cmd>Mason<cr>", { desc = "Mason" })

  require("mason-lspconfig").setup({
    -- Only LSPs goes in here
    ensure_installed = {},
  })

  -- Debuggers
  require("mason-nvim-dap").setup({
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    handlers = {},

    -- You'll need to check that you have the required things installed
    -- online, please don't ask me how to install them :)
    ensure_installed = {
      -- Update this to ensure that you have the debuggers for the langs you want
      "codelldb",
      "delve",
    },
  })

  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

  local dap_icons = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  }

  for name, sign in pairs(dap_icons) do
    sign = type(sign) == "table" and sign or { sign }
    vim.fn.sign_define(
      "Dap" .. name,

      ---@diagnostic disable-next-line: assign-type-mismatch
      { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
    )
  end

  -- setup dap config by VsCode launch.json file
  local vscode = require("dap.ext.vscode")
  local json = require("plenary.json")
  ---@diagnostic disable-next-line: duplicate-set-field
  vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
end)

-- Nonels
now(function()
  add({
    source = "nvimtools/none-ls.nvim",
    depends = { "nvim-lua/plenary.nvim" },
  })

  local nls = require("null-ls")
  local opts = {
    sources = {
      -- Docker
      nls.builtins.diagnostics.hadolint,
      -- Eslint
      -- nls.builtins.diagnostics.eslint,
      -- Go
      nls.builtins.code_actions.gomodifytags,
      nls.builtins.code_actions.impl,
      nls.builtins.formatting.goimports,
      nls.builtins.formatting.golines,
      nls.builtins.formatting.gofumpt,
      -- Hover
      nls.builtins.hover.dictionary,
      nls.builtins.hover.printenv,
      -- Lua
      nls.builtins.formatting.stylua,
      -- Markdown
      nls.builtins.formatting.cbfmt,
      nls.builtins.diagnostics.markdownlint_cli2,
      -- Prettier
      nls.builtins.formatting.prettier,
    },
  }

  nls.setup(opts)
end)

-- Setup for rust
now(function()
  add({ source = "Saecki/crates.nvim" })

  require("crates").setup({
    completion = {
      crates = {
        enabled = true,
      },
    },
    lsp = {
      enabled = true,
      actions = true,
      completion = true,
      hover = true,
    },
  })

  add({ source = "mrcjkb/rustaceanvim" })
  local rust_opts = {
    tools = {
      rustc = { default_edition = "2024" },
    },
    server = {
      on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr

          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- stylua: ignore start
        map("n", "<leader>cR", function() vim.cmd.RustLsp("codeAction") end, { desc = "Code action" })
        map("n", "<leader>dR", function() vim.cmd.RustLsp("debuggables") end, { desc = "Rust debuggables" })
        map("n", "<leader>cT", function() vim.cmd.RustLsp("testables") end, { desc = "Rust testables" })
        map("n", "<leader>cL", function() vim.cmd.RustLsp("flyCheck") end, { desc = "Rust lint (clippy)" })
        -- stylua: ignore end
      end,
      default_settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          -- Add clippy lints for Rust
          checkOnSave = true,
          -- Enable diagnostics
          diagnostics = { enable = true },
          procMacro = {
            enable = true,
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["napi-derive"] = { "napi" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
          files = {
            excludeDirs = {
              ".direnv",
              ".git",
              ".github",
              ".gitlab",
              "bin",
              "node_modules",
              "target",
              "venv",
              ".venv",
            },
          },
        },
      },
    },
  }

  vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, rust_opts or {})

  if vim.fn.executable("rust-analyzer") == 0 then
    vim.notify("rust-analyzer is not found in PATH!", vim.log.levels.WARN)
  end

  -- if using rustaceanvim, disable rust_analyzer
  vim.lsp.enable("rust_analyzer", false)
end)
