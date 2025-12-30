---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  -- Add custom filetypes
  vim.filetype.add({
    extension = {
      conf = "conf",
      env = "dotenv",
      tiltfile = "tiltfile",
      Tiltfile = "tiltfile",
    },
    filename = {
      [".env"] = "dotenv",
      ["tsconfig.json"] = "jsonc",
      ["jsconfig.json"] = "jsonc",
      [".yamlfmt"] = "yaml",
    },
    pattern = {
      ["%.env%.[%w_.-]+"] = "dotenv",
    },
  })

  add({
    source = "nvim-treesitter/nvim-treesitter",
    -- Use "main" while also monitoring updates in "main"
    checkout = "main",
    monitor = "main",
    -- Perform action after every checkout
    hooks = {
      post_checkout = function() vim.cmd("TSUpdate") end,
    },
  })

  add({
    source = "brianhuster/treesitter-endwise.nvim",
    depends = { "nvim-treesitter/nvim-treesitter" },
  })

  -- add({
  --   source = "nvim-treesitter/nvim-treesitter-context",
  --   depends = { "nvim-treesitter/nvim-treesitter" },
  -- })

  local opts = {
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then return true end
      end,
    },
    indent = { enable = true },
    folds = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "nix",
      "printf",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  }

  require("nvim-treesitter").setup(opts)
  require("nvim-treesitter").install(opts.ensure_installed)
end)

later(function() add({ source = "calops/hmts.nvim" }) end)
