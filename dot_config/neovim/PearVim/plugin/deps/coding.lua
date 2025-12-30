---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Icons
now(function()
  require("mini.icons").setup({
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
  })

  later(require("mini.icons").mock_nvim_web_devicons())
  later(require("mini.icons").tweak_lsp_kind())
end)

-- Better commenting (like gcc)
later(function() require("mini.comment").setup() end)

-- Surrounding pairs
later(function()
  require("mini.surround").setup({
    mappings = {
      add = "gsa", -- Add surrounding in Normal and Visual modes
      delete = "gsd", -- Delete surrounding
      find = "gsf", -- Find surrounding (to the right)
      find_left = "gsF", -- Find surrounding (to the left)
      highlight = "gsh", -- Highlight surrounding
      replace = "gsr", -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`
    },
  })
end)

-- Better text-objects
now(function()
  local ai = require("mini.ai")

  require("mini.ai").setup({
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
  })
end)

-- Manage character pairs (), [], {}, etc.
now(function()
  local opts = {
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
  }

  local pairs = require("mini.pairs")
  pairs.setup(opts)
  local open = pairs.open
  pairs.open = function(pair, neigh_pattern)
    if vim.fn.getcmdline() ~= "" then return open(pair, neigh_pattern) end
    local o, c = pair:sub(1, 1), pair:sub(2, 2)
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local next = line:sub(cursor[2] + 1, cursor[2] + 1)
    local before = line:sub(1, cursor[2])
    if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
      return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
    end
    if opts.skip_next and next ~= "" and next:match(opts.skip_next) then return o end
    if opts.skip_ts and #opts.skip_ts > 0 then
      local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
      for _, capture in ipairs(ok and captures or {}) do
        if vim.tbl_contains(opts.skip_ts, capture.capture) then return o end
      end
    end
    if opts.skip_unbalanced and next == c and c ~= o then
      local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
      local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
      if count_close > count_open then return o end
    end
    return open(pair, neigh_pattern)
  end
end)
