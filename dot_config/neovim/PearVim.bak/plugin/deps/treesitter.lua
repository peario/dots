---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
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
      -- ["tsconfig.json"] = "jsonc",
      -- ["jsconfig.json"] = "jsonc",
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
    hooks = {
      post_checkout = function()
        -- Only update if this is actually a fresh checkout
        local treesitter_path = vim.fn.stdpath("data") .. "/site/pack/deps/opt/nvim-treesitter"
        if vim.fn.isdirectory(treesitter_path) == 1 then
          -- Only attempt to update parsers if the treesitter path exists
          vim.cmd("TSUpdate")
        end
      end,
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

  -- Don't call require('nvim-treesitter').setup() at startup]
  -- Instead, setup only when first opening a file
  vim.api.nvim_create_autocmd("FileType", {
    once = true,
    callback = function() require("nvim-treesitter").setup(opts) end,
  })

  -- NOTE: This function can cause up to ~60s blocking on startup. Be careful.
  -- vim.schedule(function() require("nvim-treesitter").install(opts.ensure_installed) end)
end)

later(function() add({ source = "calops/hmts.nvim" }) end)
