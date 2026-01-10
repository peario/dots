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

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy", -- TODO: Implement "LazyFile" and replace current event
     opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },


  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "VeryLazy", -- TODO: Switch to "LazyFile" once implemented
    opts = {},
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
}
