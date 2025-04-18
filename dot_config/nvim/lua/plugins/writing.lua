return {
  --- LaTeX-related writing
  {
    "lervag/vimtex",
    ft = { "tex", "latex", "plaintex", "bibtex" },
    lazy = false, -- lazy-loading will disable inverse search
    init = function()
      -- Move auxiliary files to subfolder to reduce clutter
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "./auxiliary",
        out_dir = ".",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        hooks = {},
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      -- setup a pdf-viewer, will later be switched to a terminal pdf-viewer
      local hasSioyek = vim.fn.executable("sioyek") == 1
      local hasZathura = vim.fn.executable("zathura") == 1
      local hasPplatex = vim.fn.executable("pplatex") == 1

      vim.g.vimtex_view_method = hasSioyek and "sioyek" or hasZathura and "zathura"
      vim.g.vimtex_view_sioyek_options = "--reuse-window"

      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = hasPplatex and "pplatex" or "latexlog"
      vim.g.vimtex_quickfix_mode = 0 -- Don't automatically show/hide quickfix window on save/build
    end,
    keys = {
      { "<localleader>l", "", desc = "+vimtext" },
      -- {
      --   "<C-i>",
      --   function()
      --     local success, vimtex = pcall(vim.api.nvim_buf_get_var, 0, "vimtex")
      --
      --     if not success then
      --       vim.notify("Could not get [b:vimtex]: " .. vimtex, vim.log.levels.ERROR, { title = "VimTeX: Figures" })
      --       return
      --     end
      --
      --     -- Retrieve the root from the vimtex table
      --     local root = vimtex.root
      --     if not root then
      --       vim.notify("vimtex.root is nil", vim.log.levels.ERROR, { title = "VimTeX: Figures" })
      --       return
      --     end
      --
      --     -- Grab word/sentence from current line to use as figure name
      --     local name = vim.fn.getline(".")
      --     local line = vim.api.nvim_win_get_cursor(0)[1]
      --     local min_len = 3
      --
      --     if string.len(name) <= min_len then
      --       vim.notify(
      --         ("No word or sentence at %d.\nMinimum length: %d"):format(line, min_len),
      --         vim.log.levels.WARN,
      --         { title = "VimTeX: Figures" }
      --       )
      --     end
      --
      --     vim.cmd('silent !inkfigs create "' .. name .. '" "' .. root .. '/figures/"')
      --     vim.cmd("w")
      --   end,
      --   silent = true,
      --   desc = "New figure",
      --   mode = "i",
      -- },
      -- {
      --   "<localleader>e",
      --   function()
      --     local ok, vimtex = pcall(vim.api.nvim_buf_get_var, 0, "vimtex")
      --
      --     if not ok then
      --       vim.notify("Could not get [b:vimtex]: " .. vimtex, vim.log.levels.ERROR, { title = "VimTeX: Figures" })
      --       return
      --     end
      --
      --     -- Retrieve the root from the vimtex table
      --     local root = vimtex.root
      --     if not root then
      --       vim.notify("vimtex.root is nil", vim.log.levels.ERROR, { title = "VimTeX: Figures" })
      --       return
      --     end
      --
      --     vim.cmd('silent !inkfigs edit "' .. root .. '/figures/" > /dev/null 2>&1 &')
      --     vim.cmd("redraw!")
      --   end,
      --   silent = true,
      --   desc = "Edit figure",
      --   mode = "n",
      -- },
    },
  },
  --- Typst
  -- Preview
  {
    "chomosuke/typst-preview.nvim",
    ft = { "typst" },
    event = "LazyFile",
    version = "1.*",
    opts = {},
  },
  -- General
  {
    "kaarmu/typst.vim",
    ft = { "typst" },
    event = "LazyFile",
    lazy = false,
    -- init = function() end,
  },
  --- Other
  -- LSP and such for LaTeX
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        texlab = {
          auxDirectory = "./auxiliary",
          build = {
            onSave = true,
          },
          latexindent = {
            modifyLineBreaks = true,
          },
          keys = {
            { "<localleader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
          },
        },
      },
    },
  },
  -- Make vimtex handle syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        disable = { "latex" },
      },
    },
  },
  -- Horizontal highlights for text filetypes, like markdown, orgmode, and neorg.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "vimwiki", "norg", "rmd", "org", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = {
        lsp = { enabled = true },
      },
      file_types = { "markdown", "vimwiki", "norg", "rmd", "org", "codecompanion" },
    },
  },
  -- Coding statistics
  {
    "wakatime/vim-wakatime",
    event = { "LazyFile", "VeryLazy" },
    lazy = false,
  },
}
