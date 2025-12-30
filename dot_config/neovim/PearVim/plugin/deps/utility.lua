---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function() add({ source = "nvim-lua/plenary.nvim" }) end)

now(function() add({ source = "b0o/SchemaStore.nvim" }) end)

now(function()
  add({
    source = "folke/which-key.nvim",
    depends = { "nvim-mini/mini.icons" },
  })

  local opts = {
    preset = "helix",
    spec = {
      {
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>dp", group = "profiler" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        {
          "<leader>b",
          group = "buffer",
          expand = function() return require("which-key.extras").expand.buf() end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function() return require("which-key.extras").expand.win() end,
        },
        -- better descriptions
        { "gx", desc = "Open with system app" },
      },
    },
  }

  local wk = require("which-key")
  wk.setup(opts)
end)

now(function()
  add({ source = "ibhagwan/fzf-lua" })

  add({
    source = "folke/trouble.nvim",
    depends = { "ibhagwan/fzf-lua" },
  })

  local trouble_loaded = false
  local function load_trouble()
    if trouble_loaded then return end
    trouble_loaded = true

    -- Manually load the plugin
    vim.cmd.packadd("trouble.nvim")

    -- Call setup with defaults
    require("trouble").setup({})

    local map = vim.keymap.set

    map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
    map(
      "n",
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      { desc = "Buffer diagnostics (Trouble)" }
    )
    map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
    map(
      "n",
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      { desc = "LSP Definitions / references / ... (Trouble)" }
    )
    map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list (Trouble)" })
    map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list (Trouble)" })
  end

  vim.api.nvim_create_autocmd({ "CmdUndefined", "FileType" }, {
    pattern = "*",
    callback = function()
      if vim.fn.exists(":Trouble") == 0 then vim.schedule(load_trouble) end
    end,
  })

  vim.keymap.set({ "n", "v" }, "<leader>x", "", {
    callback = function() load_trouble() end,
    silent = true,
    noremap = true,
  })
end)
