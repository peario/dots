---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

---@class starter.item
---@field icon? string
---@field name string
---@field action string
---@field section string

-- Dashboard
now(function()
  -- included with mini.deps
  local starter = require("mini.starter")

  ---@type (starter.item|fun():starter.item)[]
  local items = {
    -- Manage plugins, tools, highlights, etc.
    function()
      return {
        { icon = "󰏓 ", name = "Plugins", action = "DepsUpdate", section = "Management" },
        { icon = "󰐱 ", name = "Tools", action = "Mason", section = "Management" },
        { icon = "󰸱 ", name = "Highlights (update)", action = "TSUpdate", section = "Management" },
        { icon = "󰶯 ", name = "Checkhealth", action = "checkhealth", section = "Management" },
      }
    end,
    -- Files finder
    function()
      local dot_path = vim.fs.normalize(vim.fn.stdpath("config"))

      if not (vim.fn.exists(":FzfLua") > 0) then return {} end

      return {
        { icon = "󰍉 ", name = "Live grep", action = "FzfLua live_grep", section = "Fuzzy finder" },
        { icon = "󰒓 ", name = "Files", action = "FzfLua files", section = "Fuzzy finder" },
        { icon = "󰀼 ", name = "Old files", action = "FzfLua oldfiles", section = "Fuzzy finder" },
        { icon = "󰋚 ", name = "Command History", action = "FzfLua command_history", section = "Fuzzy finder" },
        { icon = "󱚊 ", name = "Help tags", action = "FzfLua helptags", section = "Fuzzy finder" },
        { icon = "󰒓 ", name = "Config", action = "FzfLua files cwd=" .. dot_path, section = "Fuzzy finder" },
      }
    end,
  }

  local function add_icons(bullet, place_cursor)
    bullet = bullet or "░ "

    if place_cursor == nil then place_cursor = true end
    return function(content)
      local coords = starter.content_coords(content, "item")
      -- Go backwards to avoid conflict when inserting units
      for i = #coords, 1, -1 do
        local l_num, u_num = coords[i].line, coords[i].unit
        local icon = content[l_num][u_num].item.icon
        local bullet_unit = {
          string = (icon ~= nil and icon ~= "") and icon or bullet,
          type = "item_bullet",
          hl = (icon ~= nil and icon ~= "") and "MiniStarterItemPrefix" or "MiniStarterItemBullet",
          -- Use `_item` instead of `item` because it is better to be 'private'
          _item = content[l_num][u_num].item,
          _place_cursor = place_cursor,
        }
        table.insert(content[l_num], u_num, bullet_unit)
      end

      return content
    end
  end

  starter.setup({
    -- NOTE: icons at the start of item's name removes the "query"-feature from that item
    items = items,
    content_hooks = {
      starter.gen_hook.aligning("center", "center"),
      add_icons(),
    },
  })
end)

-- Bufferline
-- now(function()
--   add({
--     source = "akinsho/bufferline.nvim",
--     depends = { "nvim-mini/mini.icons" },
--   })
--
--   require("bufferline").setup()
-- end)

-- Statusline
now(function()
  add({
    source = "nvim-lualine/lualine.nvim",
    depends = { "nvim-mini/mini.icons" },
  })

  require("lualine").setup({})
end)

-- Gitsigns
later(function()
  add({ source = "lewis6991/gitsigns.nvim" })

  require("gitsigns").setup({
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

      local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

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
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
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
  })
end)

-- Fuzzy finder
now(function()
  add({
    source = "ibhagwan/fzf-lua",
    depends = { "nvim-mini/mini.icons" },
  })

  local fzf = require("fzf-lua")
  local config = fzf.config
  local actions = fzf.actions

  -- Quickfix
  config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
  config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
  config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
  config.defaults.keymap.fzf["ctrl-x"] = "jump"
  config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
  config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
  config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
  config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

  config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]

  local img_previewer ---@type string[]?
  for _, v in ipairs({
    { cmd = "ueberzug", args = {} },
    { cmd = "chafa", args = { "{file}", "--format=symbols" } },
    { cmd = "viu", args = { "-b" } },
  }) do
    if vim.fn.executable(v.cmd) == 1 then
      img_previewer = vim.list_extend({ v.cmd }, v.args)
      break
    end
  end

  local opts = {
    "skim",
    fzf_colors = true,
    fzf_opts = {
      ["--no-scrollbar"] = true,
    },
    defaults = {
      -- formatter = "path.filename_first",
      formatter = "path.filename_first",
    },
    previewers = {
      cat = {
        -- this is only due to me having alias'd bat to cat
        cmd = "/bin/cat",
      },
      builtin = {
        extensions = {
          ["png"] = img_previewer,
          ["jpg"] = img_previewer,
          ["jpeg"] = img_previewer,
          ["gif"] = img_previewer,
          ["webp"] = img_previewer,
        },
        ueberzug_scaler = "fit_contain",
      },
    },
    -- Custom option to configure vim.ui.select
    ui_select = function(fzf_opts, items)
      return vim.tbl_deep_extend("force", fzf_opts, {
        prompt = " ",
        winopts = {
          title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
          title_pos = "center",
        },
      }, fzf_opts.kind == "codeaction" and {
        winopts = {
          layout = "vertical",
          -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
          height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
          width = 0.5,
          preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
            layout = "vertical",
            vertical = "down:15,border-top",
            hidden = "hidden",
          } or {
            layout = "vertical",
            vertical = "down:15,border-top",
          },
        },
      } or {
        winopts = {
          width = 0.5,
          -- height is number of items, with a max of 80% screen height
          height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
        },
      })
    end,
    winopts = {
      width = 0.8,
      height = 0.8,
      row = 0.5,
      col = 0.5,
      preview = {
        scrollchars = { "┃", "" },
      },
    },
    files = {
      cwd_prompt = false,
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    },
    grep = {
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    },
    lsp = {
      symbols = {
        symbol_hl = function(s) return "TroubleIcon" .. s end,
        symbol_fmt = function(s) return s:lower() .. "\t" end,
        child_prefix = false,
      },
      code_actions = {
        previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
      },
    },
  }

  if opts[1] == "default-title" then
    -- use the same prompt for all pickers for profile `default-title` and
    -- profiles that use `default-title` as base profile
    local function fix(t)
      t.prompt = t.prompt ~= nil and " " or nil
      for _, v in pairs(t) do
        if type(v) == "table" then fix(v) end
      end
      return t
    end
    opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
    opts[1] = nil
  end

  require("fzf-lua").setup(opts)

  ---@type table<string, string[]|boolean>?
  local kind_filter = {
    default = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      -- "Package", -- remove package since luals uses it for control flow structures
      "Property",
      "Struct",
      "Trait",
    },
  }

  local function get_kind_filter(buf)
    buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
    local ft = vim.bo[buf].filetype
    if kind_filter == false or kind_filter == nil then return end
    if kind_filter[ft] == false then return end
    if type(kind_filter[ft]) == "table" then return kind_filter[ft] end
    ---@diagnostic disable-next-line: return-type-mismatch
    return type(kind_filter) == "table" and type(kind_filter.default) == "table" and kind_filter.default or nil
  end

  local function symbols_filter(entry, ctx)
    if ctx.symbols_filter == nil then ctx.symbols_filter = get_kind_filter(ctx.bufnr) or false end
    if ctx.symbols_filter == false then return true end
    ---@diagnostic disable-next-line: param-type-mismatch
    return vim.tbl_contains(ctx.symbols_filter, entry.kind)
  end

  -- Keymaps
  local map = vim.keymap.set

  -- stylua: ignore start
  map("t", "<C-j>", "<C-j>", { nowait = true })
  map("t", "<C-k>", "<C-k>", { nowait = true })
  map("n", "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", { desc = "Switch buffer" })
  map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Grep (root)" })
  map("n", "<leader>:", "<cmd>FzfLua command_history<cr>", { desc = "Command history" })
  map("n", "<leader><space>", "<cmd>FzfLua files<cr>", { desc = "Find files (root)" })
  -- find
  map("n", "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", { desc = "Buffers"})
  map("n", "<leader>fc", function()
    require("fzf-lua").files({
      cwd = vim.fs.normalize(vim.fn.stdpath("config"))
    })
  end, { desc = "Find config file"})
  map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files (root)"})
  map("n", "<leader>fF", function()
    local path = vim.uv.cwd()
    local valid_path = not (path == "" or path == nil)

    require("fzf-lua").files({
      cwd = valid_path and vim.fs.normalize(path) or nil,
    })
  end, { desc = "Find files (cwd)"})
  map("n", "<leader>fg", "<cmd>FzfLua git_files<cr>", { desc = "Find files (git)"})
  map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent"})
  map("n", "<leader>fR", function()
    local path = vim.uv.cwd()
    local valid_path = not (path == "" or path == nil)

    require("fzf-lua").oldfiles({
      cwd = valid_path and vim.fs.normalize(path) or nil,
    })
  end, { desc = "Recent (cwd)"})
  -- git
  map("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", { desc = "Commits" })
  map("n", "<leader>gs", "<cmd>FzfLua git_status<cr>", { desc = "Status" })
  -- search
  map("n", '<leader>s"', "<cmd>FzfLua registers<cr>", { desc = "Registers" })
  map("n", "<leader>sa", "<cmd>FzfLua autocmds<cr>", { desc = "Auto commands" })
  map("n", "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", { desc = "Buffer" })
  map("n", "<leader>sc", "<cmd>FzfLua command_history<cr>", { desc = "Command history" })
  map("n", "<leader>sC", "<cmd>FzfLua commands<cr>", { desc = "Commmands" })
  map("n", "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Document diagnostics" })
  map("n", "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Workspace diagnostics" })
  map("n", "<leader>sg", "<cmd>FzfLua live_grep<cr>", { desc = "Grep (root)" })
  map("n", "<leader>sG", function()
    local path = vim.uv.cwd()
    local valid_path = not (path == "" or path == nil)

    require("fzf-lua").grep({
      cwd = valid_path and vim.fs.normalize(path) or nil,
    })
  end, { desc = "Grep (cwd)"})
  map("n", "<leader>sh", "<cmd>FzfLua help_tags<cr>", { desc = "Help pages" })
  map("n", "<leader>sH", "<cmd>FzfLua highlights<cr>", { desc = "Search highlight groups" })
  map("n", "<leader>sj", "<cmd>FzfLua jumps<cr>", { desc = "Jumplist" })
  map("n", "<leader>sk", "<cmd>FzfLua keymaps<cr>", { desc = "Key maps" })
  map("n", "<leader>sl", "<cmd>FzfLua loclist<cr>", { desc = "Location list" })
  map("n", "<leader>sM", "<cmd>FzfLua man_pages<cr>", { desc = "Man pages" })
  map("n", "<leader>sm", "<cmd>FzfLua marks<cr>", { desc = "Jump to mark" })
  map("n", "<leader>sR", "<cmd>FzfLua resume<cr>", { desc = "Resume" })
  map("n", "<leader>sq", "<cmd>FzfLua quickfix<cr>", { desc = "Quickfix list" })
  map("n", "<leader>sw", "<cmd>FzfLua grep_cword<cr>", { desc = "Word (root)" })
  map("n", "<leader>sW", function()
    local path = vim.uv.cwd()
    local valid_path = not (path == "" or path == nil)

    require("fzf-lua").grep_cword({
      cwd = valid_path and vim.fs.normalize(path) or nil,
    })
  end, { desc = "Word (cwd)" })
  map("v", "<leader>sw", "<cmd>FzfLua grep_visual<cr>", { desc = "Selection (root)" })
  map("v", "<leader>sW", function()
    local path = vim.uv.cwd()
    local valid_path = not (path == "" or path == nil)

    require("fzf-lua").grep_visual({
      cwd = valid_path and vim.fs.normalize(path) or nil,
    })
  end, { desc = "Selection (cwd)" })
  map("n", "<leader>uC", "<cmd>FzfLua colorschemes<cr>", { desc = "Colorscheme (with preview)" })
  map("n", "<leader>ss", function()
    require("fzf-lua").lsp_document_symbols({
      regex_filter = symbols_filter,
    })
  end, { desc = "Goto symbol" })
  map("n", "<leader>sS", function()
    require("fzf-lua").lsp_live_workspace_symbols({
      regex_filter = symbols_filter,
    })
  end, { desc = "Goto symbol (workspace)" })

  -- stylua: ignore end
end)
