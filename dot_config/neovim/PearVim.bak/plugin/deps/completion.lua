---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- snippets
-- later(function()
--   local build = function()
--     local out = vim.fn.system({ "make", " install_jsregexp" })
--
--     if vim.v.shell_error ~= 0 then
--       vim.api.nvim_echo({
--         { "Failed to build LuaSnip (jsregexp):\n", "ErrorMsg" },
--         { out, "WarningMsg" },
--       }, true, {})
--     end
--   end
--
--   add({
--     source = "L3MON4D3/LuaSnip",
--     checkout = "v2.*",
--     monitor = "master",
--     hooks = {
--       post_install = function() later(build) end,
--       post_checkout = build,
--     },
--     depends = { "rafamadriz/friendly-snippets" },
--   })
--
--   require("luasnip").setup({
--     enable_autosnippets = true,
--     store_selection_keys = "<Tab>",
--     updateevents = "TextChanged,TextChangedI",
--     snip_env = {},
--   })
--
--   local snippets_path = vim.fs.normalize(vim.fn.stdpath("config") .. "/snippets")
--
--   if vim.fn.isdirectory(snippets_path) > 0 then
--     require("luasnip.loaders.from_lua").load({ paths = snippets_path .. "/lua" })
--     require("luasnip.loaders.from_vscode").load({ paths = snippets_path .. "/vscode" })
--     require("luasnip.loaders.from_snipmate").load({ paths = snippets_path .. "/snipmate" })
--   end
-- end)

-- blink
later(function()
  add({
    source = "saghen/blink.cmp",
    checkout = "v1.6.0",
    depends = { "saghen/blink.compat", "nvim-mini/mini.icons", "folke/lazydev.nvim" },
  })

  ---@module "blink.cmp"
  ---@diagnostic disable-next-line: undefined-doc-name
  ---@type blink.cmp.Config
  local opts = {
    fuzzy = {
      prebuilt_binaries = {
        -- always compile since we track "main"
        download = true,
      },
      -- For some reason this errors
      implementation = "prefer_rust",
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

      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "snippet_backward", "fallback_to_mappings" },
      ["<C-n>"] = { "snippet_forward", "fallback_to_mappings" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      -- ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = false,
      -- On another config I used "normal"
      -- LazyVim uses "mono"
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
          preselect = function(_) return not require("blink.cmp").snippet_active({ direction = 1 }) end,
          auto_insert = true,
        },
      },
      ghost_text = { enabled = false },
    },

    sources = {
      compat = { "crates" },
      default = function()
        local type = vim.fn.getcmdtype()
        local success, node = pcall(vim.treesitter.get_node)

        -- if within a comment
        if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
          return { "buffer" }
        end

        -- if within a / or ? search for string
        if type == "/" or type == "?" then return { "buffer" } end

        -- if within : or @ command mode
        if type == ":" or type == "@" then return { "cmdline", "path" } end

        -- if within a lua-file
        if vim.bo.filetype == "lua" then return { "lazydev", "lsp", "snippets", "path" } end

        -- if none of the branches above has a match
        return { "lsp", "snippets", "path" }
      end,
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
      -- https://cmp.saghen.dev/modes/cmdline.html#keymap-preset
      enabled = true,
    },
  }

  local enabled = opts.sources.default()
  for _, source in ipairs(opts.sources.compat or {}) do
    opts.sources.providers[source] = vim.tbl_deep_extend(
      "force",
      { name = source, module = "blink.compat.source" },
      opts.sources.providers[source] or {}
    )
    if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then table.insert(enabled, source) end
  end

  -- Unset custom prop to pass blink.cmp validation
  ---@diagnostic disable-next-line: inject-field
  opts.sources.compat = nil

  require("blink.cmp").setup(opts)
end)
