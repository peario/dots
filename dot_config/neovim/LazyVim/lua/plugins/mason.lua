-- This file (`mason.lua`) is intended to contain installation of tools, LSPs, DAPs, etc.
return {
  -- Lazy load mason, mason-lspconfig and mason-tool-installer
  {
    "williamboman/mason.nvim",
    version = "*",
    lazy = false,
    -- event = { "LazyFile" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    -- event = { "LazyFile" },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    --@see https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39#issuecomment-1904702032
    lazy = false,
    enabled = false,
    -- event = { "LazyFile" },
    cmd = {
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
      "MasonToolsClean",
    },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    keys = {
      { "<leader>cM", "<cmd>MasonToolsUpdate<CR>", desc = "Mason Install / Update" },
    },
    opts = {
      auto_update = true, -- automatically update the tools in `opts.ensure_installed`
      run_on_start = true, -- automatically install / update tools on startup (nvim)
      -- NOTE: Any tool used from "nvimtools/none-ls.nvim" needs to be installed, place them here
      ensure_installed = {
        -- DAP
        "codelldb", -- LazyExtras clangd and rust
        "debugpy", -- LazyExtras python
        "delve", -- LazyExtras go
        "js-debug-adapter", -- LazyExtras typescript
        "kotlin-debug-adapter", -- LazyExtras kotlin
        -- LSP
        -- "bacon-ls", -- LazyExtras rust
        "asm_lsp",
        "bash-language-server", -- LazyExtras dot
        "clangd", -- LazyExtras clangd
        "docker-compose-language-service", -- LazyExtras docker
        "dockerfile-language-server", -- LazyExtras docker
        "elixir-ls", -- LazyExtras elixir (also a dap)
        "gopls", -- LazyExtras go
        "jsonls", -- LazyExtras JSON
        "kotlin-language-server", -- LazyExtras kotlin
        "marksman", -- LazyExtras markdown
        "ruff", -- LazyExtras python
        "rust-analyzer", -- LazyExtras rust
        "svelte-language-server", -- LazyExtras svelte
        "stylelint-lsp",
        "tailwindcss-language-server", -- LazyExtras tailwindcss
        "taplo", -- LazyExtras toml
        "texlab", -- LazyExtras tex
        "tinymist",
        "typescript-language-server", -- LazyExtras typescript
        "vtsls", -- LazyExtras typescript
        "vue-language-server", -- LazyExtras vue
        "yaml-language-server", -- LazyExtras yaml
        -- linters
        "actionlint",
        "alex", -- catch insensitive, inconsiderate writing
        "commitlint",
        "dotenv-linter",
        "eslint", -- LazyExtras eslint
        "hadolint", -- LazyExtras docker
        "ktlint", -- LazyExtras kotlin
        "markdownlint-cli2", -- LazyExtras markdown
        "revive",
        "shellcheck", -- LazyExtras dot
        "sqruff", -- preferred over sqlfluff (imo)
        "sqlfluff", -- LazyExtras sql
        "trivy",
        -- formatters
        "asmfmt",
        "beautysh", -- for zsh formatting
        "buf",
        "cbfmt",
        "clang-format",
        "goimports", -- LazyExtras go
        "gofumpt", -- LazyExtras go
        "golines", -- LazyExtras go
        "gomodifytags", -- LazyExtras go
        "markdown-toc", -- LazyExtras markdown
        "prettier", -- LazyExtras prettier
        "rustywind",
        "shellharden",
        "shfmt", -- LazyExtras none-ls
        "stylua", -- LazyExtras none-ls
        -- other
        "gitui", -- LazyExtras gitui
        "impl", -- LazyExtras go
      },
    },
    config = function(_, opts)
      -- set up integrations here (can't use function with the setup below in opts)
      local is_ok, lazyUtil = pcall(require, "lazyvim.util")
      opts.integrations = vim.list_extend(opts.integrations or {}, {
        ["mason-lspconfig"] = is_ok and lazyUtil.has("mason-lspconfig") or true,
        ["mason-null-ls"] = is_ok and lazyUtil.has("mason-null-ls") or false,
        ["mason-nvim-dap"] = is_ok and lazyUtil.has("mason-nvim-dap") or false,
      })

      -- Conditional mason-install
      local hasNix = vim.fn.executable("nix") == 1
      opts.ensure_installed = hasNix
        and vim.list_extend(opts.ensure_installed or {}, {
          -- LSP
          "nil",
          -- Diagnostics
          -- "deadnix", -- not installable via mason
          -- "statix", -- not installable via mason
          -- Formatting
          "nixpkgs-fmt",
        })

      -- setup after integrations is done (above)
      require("mason-tool-installer").setup(opts)
    end,
  },
}
