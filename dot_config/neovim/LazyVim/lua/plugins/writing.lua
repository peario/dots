--- Verifies if a file exists
---@param name string the name of the file to open (include extension)
---@return boolean
local function file_exists(name)
  ---@param path string
  local function exists(path)
    return os.rename(path, path) and true or false
  end

  if not exists(name) then
    return false
  end
  local f = io.open(name)
  if f then
    f:close()
    return true
  end
  return false
end

return {
  --- LaTeX-related writing
  {
    "lervag/vimtex",
    tag = "v2.16",
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
      -- local hasSioyek = vim.fn.executable("sioyek") == 1
      -- local hasZathura = vim.fn.executable("zathura") == 1
      local hasPplatex = vim.fn.executable("pplatex") == 1

      -- vim.g.vimtex_ui_method = "nvim"
      -- vim.g.vimtex_callback_progpath = "/usr/local/bin/nvim"
      vim.g.vimtex_view_method = "zathura"
      -- vim.g.vimtex_view_zathura_options = "--fork"
      vim.g.vimtex_view_sioyek_options = "--reuse-window"

      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = hasPplatex and "pplatex" or "latexlog"
      vim.g.vimtex_quickfix_mode = 0 -- Don't automatically show/hide quickfix window on save/build
    end,
    keys = {
      { "<localleader>l", "", desc = "+vimtex" },
      {
        "<C-i>",
        function()
          local success, vimtex = pcall(vim.api.nvim_buf_get_var, 0, "vimtex")

          if not success then
            vim.notify("Could not get [b:vimtex]: " .. vimtex, vim.log.levels.ERROR, { title = "VimTeX: Figures" })
            return
          end

          -- Retrieve the root from the vimtex table
          local root = vimtex.root
          if not root then
            vim.notify("vimtex.root is nil", vim.log.levels.ERROR, { title = "VimTeX: Figures" })
            return
          end

          -- Grab word/sentence from current line to use as figure name
          local name = vim.fn.getline(".")
          local line = vim.api.nvim_win_get_cursor(0)[1]
          local min_len = 3

          if string.len(name) <= min_len then
            vim.notify(
              ("No word or sentence at %d.\nMinimum length: %d"):format(line, min_len),
              vim.log.levels.WARN,
              { title = "VimTeX: Figures" }
            )
          end

          vim.cmd('silent !inkfigs create "' .. name .. '" "' .. root .. '/figures/"')
          vim.cmd("w")
        end,
        silent = true,
        desc = "New figure",
        mode = "i",
        ft = { "tex", "latex", "plaintex", "bibtex" },
      },
      {
        "<localleader>e",
        function()
          local ok, vimtex = pcall(vim.api.nvim_buf_get_var, 0, "vimtex")

          if not ok then
            vim.notify("Could not get [b:vimtex]: " .. vimtex, vim.log.levels.ERROR, { title = "VimTeX: Figures" })
            return
          end

          -- Retrieve the root from the vimtex table
          local root = vimtex.root
          if not root then
            vim.notify("vimtex.root is nil", vim.log.levels.ERROR, { title = "VimTeX: Figures" })
            return
          end

          vim.cmd('silent !inkfigs edit "' .. root .. '/figures/" > /dev/null 2>&1 &')
          vim.cmd("redraw!")
        end,
        silent = true,
        desc = "Edit figure",
        mode = "n",
        ft = { "tex", "latex", "plaintex", "bibtex" },
      },
    },
  },
  --- Typst
  -- Preview
  {
    "chomosuke/typst-preview.nvim",
    ft = { "typst", "typ" },
    event = "LazyFile",
    version = "1.*",
  },
  -- General
  {
    "kaarmu/typst.vim",
    ft = { "typst", "typ" },
    event = "LazyFile",
    lazy = false,
    -- init = function() end,
    keys = {
      {
        "<localleader>fw",
        function()
          vim.cmd("vsp")
          vim.cmd("vertical resize 20")
          vim.cmd("terminal typst watch " .. vim.fn.expand("%:"))
          vim.cmd("normal <C-w>h")
        end,
        silent = false,
        remap = false,
        desc = "Open typst watch in split",
        mode = "n",
        ft = { "typst", "typ" },
      },
      {
        "<localleader>fz",
        function()
          local hasZathura = vim.fn.executable("zathura") == 1

          if not hasZathura then
            vim.notify('Could not find a binary named "Zathura"', vim.log.levels.ERROR, { title = "Typst: Open PDF" })
            return
          end

          local fileName = ("%s.pdf"):format(vim.fn.expand("%:p:r"))
          local fileExists = file_exists(fileName)

          if not fileExists then
            vim.notify(
              "Could not find a PDF-file by the name " .. fileName,
              vim.log.levels.ERROR,
              { title = "Typst: Open PDF" }
            )
            return
          end

          vim.cmd(string.format([[silent exec "!zathura --fork \"%s\" &"]], fileName))
        end,
        silent = true,
        remap = false,
        desc = "Open PDF in Zathura",
        ft = { "typst", "typ" },
      },
      -- FIX: sioyek is currently broken.
      --  Zathura seems to work due to it's `--fork` flag to run in the background,
      --  no real difference otherwise compared to sioyek.
      -- {
      --   "<localleader>fs",
      --   function()
      --     local hasSioyek = vim.fn.executable("sioyek") == 1
      --
      --     if not hasSioyek then
      --       vim.notify('Could not find a binary named "Sioyek"', vim.log.levels.ERROR, { title = "Typst: Open PDF" })
      --       return
      --     end
      --
      --     local fileName = ("%s.pdf"):format(vim.fn.expand("%:p:r"))
      --     local fileExists = file_exists(fileName)
      --
      --     if not fileExists then
      --       vim.notify(
      --         "Could not find a PDF-file by the name " .. fileName,
      --         vim.log.levels.ERROR,
      --         { title = "Typst: Open PDF" }
      --       )
      --       return
      --     end
      --
      --     vim.cmd(string.format([[silent exec "!sioyek --new-window \"%s\" &"]], fileName))
      --   end,
      --   silent = true,
      --   remap = false,
      --   desc = "Open PDF in Sioyek",
      --   ft = { "typst", "typ" },
      -- },
    },
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
            {
              "<localleader>K",
              "<plug>(vimtex-doc-package)",
              desc = "Vimtex Docs",
              silent = true,
            },
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
  {
    "zk-org/zk-nvim",
    lazy = true,
    opts = { picker = "snacks_picker" },
    config = function(opts, _)
      require("zk").setup(opts)
    end,
  },
  -- Coding statistics
  {
    "wakatime/vim-wakatime",
    event = { "LazyFile", "VeryLazy" },
    lazy = false,
  },
  -- Competitive Programming
  {
    "A7lavinraj/assistant.nvim",
    lazy = false,
    keys = {
      { "<leader>a", "<cmd>Assistant<cr>", desc = "Assistant.nvim" },
    },
    opts = {},
  },
}
