---@diagnostic disable-next-line: unused-local
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add({ source = "f-person/auto-dark-mode.nvim" })
  local auto_dark_mode = require("auto-dark-mode")

  auto_dark_mode.setup({
    update_interval = 1000,
    set_dark_mode = function() vim.api.nvim_set_option_value("background", "dark", {}) end,
    set_light_mode = function() vim.api.nvim_set_option_value("background", "light", {}) end,
  })
end)

now(function()
  add({ source = "catppuccin/nvim", name = "catppuccin" })

  require("catppuccin").setup({
    background = {
      light = "latte",
      dark = "macchiato",
    },
  })

  vim.cmd("colorscheme catppuccin")
end)

-- now(function()
--   add({
--     source = "everviolet/nvim",
--     name = "evergarden",
--   })
--
--   require("evergarden").setup({
--     theme = "spring",
--     accent = "green",
--   })
--
--   vim.cmd("colorscheme evergarden")
-- end)

-- now(function()
--   add({
--     source = "rose-pine/neovim",
--     name = "rose-pine",
--   })
--
--   require("rose-pine").setup({
--     variant = "auto",
--     dark_variant = "main",
--     styles = {
--       transparency = true,
--     },
--   })
--
--   vim.cmd("colorscheme rose-pine")
-- end)

-- now(function()
--   add({ source = "darianmorat/gruvdark.nvim" })
--
--   require("gruvdark").setup({ transparent = true })
--
--   vim.cmd("colorscheme gruvdark")
-- end)
