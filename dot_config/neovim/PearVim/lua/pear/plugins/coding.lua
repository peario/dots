vim.g.blink_use_main = false

local CompletionIcons = {
  Array = " ",
  Boolean = "󰨙 ",
  Class = " ",
  Codeium = "󰘦 ",
  Color = " ",
  Control = " ",
  Collapsed = " ",
  Constant = "󰏿 ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = "󰊕 ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = "󰊕 ",
  Module = " ",
  Namespace = "󰦮 ",
  Null = " ",
  Number = "󰎠 ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = "󱄽 ",
  String = " ",
  Struct = "󰆼 ",
  Supermaven = " ",
  TabNine = "󰏚 ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = "󰀫 ",
}

return {
  -- better text-objects
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    version = "*",
    opts = function()
      local ai = require("mini.ai")

      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
  -- manage pairs of surrounding chars: (), [], {}, etc.
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      local pairs = require("mini.pairs")
      pairs.setup(opts)
      local open = pairs.open
      pairs.open = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" then
          return open(pair, neigh_pattern)
        end
        local o, c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next = line:sub(cursor[2] + 1, cursor[2] + 1)
        local before = line:sub(1, cursor[2])
        if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
          return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
        end
        if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
          return o
        end
        if opts.skip_ts and #opts.skip_ts > 0 then
          local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
          for _, capture in ipairs(ok and captures or {}) do
            if vim.tbl_contains(opts.skip_ts, capture.capture) then
              return o
            end
          end
        end
        if opts.skip_unbalanced and next == c and c ~= o then
          local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
          local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
          if count_close > count_open then
            return o
          end
        end
        return open(pair, neigh_pattern)
      end
    end,
  },
  -- Surrounding selections
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
  -- Better commenting
  { "nvim-mini/mini.comment", event = "VeryLazy" },
  -- Icons
  {
    "nvim-mini/mini.icons",
    event = "VeryLazy",
    opts = {
      ---@see Mini.icons https://github.com/echasnovski/mini.icons/blob/main/lua/mini/icons.lua#L865
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
        [".chezmoiignore"] = { glyph = "", hl = "MiniIconsGrey" },
        [".chezmoiremove"] = { glyph = "", hl = "MiniIconsGrey" },
        [".chezmoiroot"] = { glyph = "", hl = "MiniIconsGrey" },
        [".chezmoiversion"] = { glyph = "", hl = "MiniIconsGrey" },
        ["bash.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        ["json.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        ["ps1.tmpl"] = { glyph = "󰨊", hl = "MiniIconsGrey" },
        ["sh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        ["toml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        ["yaml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        ["zsh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".eslintrc.ts"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".npmrc"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".prettierrc.js"] = { glyph = "", hl = "MiniIconsPurple" },
        [".prettierrc.json"] = { glyph = "", hl = "MiniIconsPurple" },
        ["prettier.config.js"] = { glyph = "", hl = "MiniIconsPurple" },
        ["prettier.config.ts"] = { glyph = "", hl = "MiniIconsPurple" },
        ["prettier.config.mjs"] = { glyph = "", hl = "MiniIconsPurple" },
        ["prettier.config.mts"] = { glyph = "", hl = "MiniIconsPurple" },
        ["prettier.config.cjs"] = { glyph = "", hl = "MiniIconsPurple" },
        ["prettier.config.cts"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["eslint.config.ts"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["eslint.config.mjs"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["eslint.config.mts"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["eslint.config.cjs"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["eslint.config.cts"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
        ["bun.lockb"] = { glyph = "", hl = "MiniIconsYellow" },
        ["bun.lock"] = { glyph = "", hl = "MiniIconsYellow" },
      },
      ---@see Mini.icons https://github.com/echasnovski/mini.icons/blob/main/lua/mini/icons.lua#L969
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
        gotmpl = { glyph = "󰟓", hl = "MiniIconsBlue" },
        octo = { glyph = "", hl = "MiniIconsGrey" },
      },
      -- Overwrite icons with `nf-cod-*` instead of `nf-md-*`
      --  - LazyVim:           uses `nf-cod-*`
      --  - Mini.icons:        uses `nf-md-*`
      --  - nvim-web-devicons: uses `nf-dev-*`
      lsp = {
        -- LazyVim
        array = { glyph = " ", hl = "MiniIconsOrange" },
        boolean = { glyph = "󰨙 ", hl = "MiniIconsOrange" },
        class = { glyph = " ", hl = "MiniIconsPurple" },
        codeium = { glyph = "󰘦 ", hl = "MiniIconsPurple" },
        color = { glyph = " ", hl = "MiniIconsRed" },
        control = { glyph = " ", hl = "MiniIconsCyan" }, -- same as keyword? for control structures?
        collapsed = { glyph = " ", hl = "MiniIconsGrey" }, -- assuming it's for folds
        constant = { glyph = "󰏿 ", hl = "MiniIconsOrange" },
        constructor = { glyph = " ", hl = "MiniIconsAzure" },
        copilot = { glyph = " ", hl = "MiniIconsAzure" },
        enum = { glyph = " ", hl = "MiniIconsPurple" },
        enummember = { glyph = " ", hl = "MiniIconsYellow" },
        event = { glyph = " ", hl = "MiniIconsRed" },
        field = { glyph = " ", hl = "MiniIconsYellow" },
        file = { glyph = " ", hl = "MiniIconsBlue" },
        folder = { glyph = " ", hl = "MiniIconsBlue" },
        ["function"] = { glyph = "󰊕 ", hl = "MiniIconsAzure" },
        interface = { glyph = " ", hl = "MiniIconsPurple" },
        key = { glyph = " ", hl = "MiniIconsYellow" },
        keyword = { glyph = " ", hl = "MiniIconsCyan" },
        method = { glyph = "󰊕 ", hl = "MiniIconsAzure" },
        module = { glyph = " ", hl = "MiniIconsPurple" },
        namespace = { glyph = "󰦮 ", hl = "MiniIconsRed" },
        null = { glyph = " ", hl = "MiniIconsGrey" },
        number = { glyph = "󰎠 ", hl = "MiniIconsOrange" },
        object = { glyph = " ", hl = "MiniIconsGrey" },
        operator = { glyph = " ", hl = "MiniIconsCyan" },
        package = { glyph = " ", hl = "MiniIconsPurple" },
        property = { glyph = " ", hl = "MiniIconsYellow" },
        reference = { glyph = " ", hl = "MiniIconsCyan" },
        snippet = { glyph = "󱄽 ", hl = "MiniIconsGreen" },
        string = { glyph = " ", hl = "MiniIconsGreen" },
        struct = { glyph = "󰆼 ", hl = "MiniIconsPurple" },
        supermaven = { glyph = " ", hl = "MiniIconsCyan" },
        tabnine = { glyph = "󰏚 ", hl = "MiniIconsRed" },
        text = { glyph = " ", hl = "MiniIconsGreen" },
        typeparameter = { glyph = " ", hl = "MiniIconsCyan" },
        unit = { glyph = " ", hl = "MiniIconsCyan" },
        value = { glyph = " ", hl = "MiniIconsBlue" },
        variable = { glyph = "󰀫 ", hl = "MiniIconsCyan" },
      },
    },
    config = function(_, opts)
      local icons = require("mini.icons")

      icons.setup(opts)
      icons.mock_nvim_web_devicons()
      icons.tweak_lsp_kind()
    end,
  },

  -- Blink.cmp
  -- For completions
  {
    "saghen/blink.cmp",
    version = not vim.g.blink_use_main and "*",
    build = vim.g.blink_use_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- add blink.compat to dependencies
      {
        "saghen/blink.compat",
        optional = true,
        opts = {},
        version = not vim.g.blink_use_main and "*",
      },
    },
    event = { "InsertEnter", "CmdlineEnter" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      fuzzy = {
        prebuilt_binaries = {
          -- when following main, always compile.
          download = not vim.g.blink_use_main,
        },
        -- For some reason this errors
        implementation = "prefer_rust_with_warning",
      },

      -- Shows function/method description while filling in args
      signature = {
        enabled = false,
        window = { border = "rounded" },
      },

      keymap = {
        preset = "enter",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },

        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      },

      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      completion = {
        accept = {
          create_undo_point = true,
          auto_brackets = {
            enabled = true,
            default_brackets = { "(", ")" },
            kind_resolution = { enabled = true },
            semantic_token_resolution = { enabled = true },
          },
        },
        menu = {
          border = "rounded",
          draw = {
            treesitter = { "lsp" },
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
              kind = {
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          -- Might cause CPU spikes or increased CPU usage
          treesitter_highlighting = true,
        },
        list = {
          selection = {
            preselect = function(_)
              return not require("blink.cmp").snippet_active({ direction = 1 })
            end,
            auto_insert = true,
          },
        },
        ghost_text = {
          enabled = false,
        },
      },

      snippets = {
        preset = "default",
      },

      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = { "crates" },
        default = function()
          local type = vim.fn.getcmdtype()
          local success, node = pcall(vim.treesitter.get_node)

          -- if within a comment
          if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            return { "buffer" }
          end

          -- if within a / or ? search for string
          if type == "/" or type == "?" then
            return { "buffer" }
          end

          -- if within : or @ command mode
          if type == ":" or type == "@" then
            return { "cmdline", "path" }
          end

          -- if within a lua-file
          if vim.bo.filetype == "lua" then
            return { "lazydev", "lsp", "snippets", "path" }
          end

          -- if none of the branches above has a match
          return { "lsp", "snippets", "path" }
        end,
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lsp = {
            name = "LSP",
            module = "blink.cmp.sources.lsp",
            opts = {}, -- Passed to the source directly, varies by source

            --- NOTE: All of these options may be functions to get dynamic behavior
            --- See the type definitions for more information
            enabled = true, -- Whether or not to enable the provider
            async = false, -- Whether we should show the completions before this provider returns, without waiting for it
            timeout_ms = 2000, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
            transform_items = nil, -- Function to transform the items before they're returned
            should_show_items = true, -- Whether or not to show the items
            max_items = nil, -- Maximum number of items to display in the menu
            min_keyword_length = 0, -- Minimum number of characters in the keyword to trigger the provider
            -- If this provider returns 0 items, it will fallback to these providers.
            -- If multiple providers fallback to the same provider, all of the providers must return 0 items for it to fallback
            fallbacks = {},
            score_offset = 0, -- Boost/penalize the score of the items
            override = nil, -- Override the source's functions
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },

      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            ---@diagnostic disable-next-line
            auto_show = function(_ctx)
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = true },
        },
      },
    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
              item.kind_icon = CompletionIcons[item.kind_name] or item.kind_icon or nil
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },

  -- Add icons for blink.cmp
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, CompletionIcons)
    end,
  },

  -- Generate annotations (Neogen)
  {
    "danymat/neogen",
    dependencies = require("pear.utils").has("mini.snippets") and { "mini.snippets" } or {},
    cmd = "Neogen",
    keys = {
      {
        "<leader>cn",
        function()
          require("neogen").generate()
        end,
        desc = "Generate Annotations (Neogen)",
      },
    },
    opts = function(_, opts)
      if opts.snippet_engine ~= nil then
        return
      end

      local map = {
        ["LuaSnip"] = "luasnip",
        ["mini.snippets"] = "mini",
        ["nvim-snippy"] = "snippy",
        ["vim-vsnip"] = "vsnip",
      }

      for plugin, engine in pairs(map) do
        if require("pear.utils").has(plugin) then
          opts.snippet_engine = engine
          return
        end
      end

      if vim.snippet then
        opts.snippet_engine = "nvim"
      end
    end,
  },

  -- inc-rename, for renaming variables, functions, etc.
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
  },

  -- Configures LuaLS to support auto-completion and type checking
  -- while editing your Neovim configuration.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
}
