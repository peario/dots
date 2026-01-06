return {
  -- Pop-up menu showing keybinds
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        {
          mode = { "n", "x" },
          { "<leader><tab>", group = "tabs", icon = { icon = " ", color = "cyan" } },
          { "<leader>c", group = "code", icon = { icon = " ", color = "blue" } },
          { "<leader>d", group = "debug", icon = { icon = " ", color = "red" } },
          { "<leader>dp", group = "profiler", icon = { icon = " ", color = "orange" } },
          { "<leader>f", group = "file/find", icon = { icon = " ", color = "green" } },
          { "<leader>g", group = "git", icon = { icon = " ", color = "purple" } },
          { "<leader>gh", group = "hunks", icon = { icon = " ", color = "purple" } },
          { "<leader>q", group = "quit/session", icon = { icon = " ", color = "orange" } },
          { "<leader>s", group = "search", icon = { icon = " ", color = "green" } },
          { "<leader>u", group = "ui", icon = { icon = " ", color = "cyan" } },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = " ", color = "green" } },
          { "[", group = "prev", icon = { icon = " ", color = "blue" } },
          { "]", group = "next", icon = { icon = " ", color = "blue" } },
          { "g", group = "goto", icon = { icon = " ", color = "blue" } },
          { "gs", group = "surround", icon = { icon = " ", color = "blue" } },
          { "z", group = "fold", icon = { icon = " ", color = "blue" } },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end, icon = { icon = " ", color = "green" }
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end, icon = { icon = " ", color = "cyan" }
          },
          -- better descriptions
          { "gx", desc = "Open with system app", icon = { icon = " ", color = "blue" } },
        },
      },
    },
    keys = {
      { "<leader>?", function()
        require("which-key").show({ global = false })
      end, desc = "Buffer Keymaps (which-key)" },
      {
        "<C-w><space>", function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end, desc = "Window Hydra Mode (which-key)",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },

  -- Fuzzy finder
  {
    "alexpasmantier/tv.nvim",
    event = "VeryLazy",
    opts = function()
      local h = require("tv").handlers

      -- default args for `files` and `text`:
      -- args = { "--no-remote", "--no-status-bar", "--preview-size", "70", "--layout", "portrait" }

      local preview_size = 70
      local tv_args = { "--no-remote", "--no-status-bar", "--preview-size", preview_size, "--layout", "landscape" }

      return {
         -- per-channel configurations
        channels = {
          -- `files`: fuzzy find files in your project
          files = {
            keybinding = '<space><space>', -- Launch the files channel
            args = tv_args,
            -- what happens when you press a key
            handlers = {
              ['<CR>'] = h.open_as_files,         -- default: open selected files
              ['<C-q>'] = h.send_to_quickfix,     -- send to quickfix list
              ['<C-s>'] = h.open_in_split,       -- open in horizontal split
              ['<C-v>'] = h.open_in_vsplit,      -- open in vertical split
              ['<C-y>'] = h.copy_to_clipboard,   -- copy paths to clipboard
            },
          },
          -- `text`: ripgrep search through file contents
          text = {
            keybinding = '<leader>/',
            args = tv_args,
            handlers = {
              ['<CR>'] = h.open_at_line,         -- Jump to line:col in file
              ['<C-q>'] = h.send_to_quickfix,    -- Send matches to quickfix
              ['<C-s>'] = h.open_in_split,       -- Open in horizontal split
              ['<C-v>'] = h.open_in_vsplit,      -- Open in vertical split
              ['<C-y>'] = h.copy_to_clipboard,   -- Copy matches to clipboard
            },
          },
          -- `env`: search environment variables
          env = {
            keybinding = "<leader>E",
            args = tv_args,
            handlers = {
              ["<CR>"] = h.insert_at_cursor, -- Insert at cursor position
              ["<C-l>"] = h.insert_on_new_line, -- Insert on new line
              ["<C-y>"] = h.copy_to_clipboard,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("tv").setup(opts)
    end,
  },
}
