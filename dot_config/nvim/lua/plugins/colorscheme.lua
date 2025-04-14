return {
  -- TokyoNight, keep for reproduction env
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = { style = "moon" },
  },
  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    enabled = false,
    priority = 1000,
    opts = {
      flavour = "auto",
      background = {
        light = "latte",
        dark = "frappe",
      },
    },
  },
  -- OneNord :: Mix of Nord and OneDark
  {
    "rmehri01/onenord.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = "italic",
        conditionals = "italic",
      },
    },
  },
  -- Configure LazyVim to easier change theme
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "onenord" },
  },
  -- automatic colorscheme switching (depending on OS-colorscheme)
  --- requires a single theme(-name) which supports switching based on `vim.o.background` value
  --- @see https://www.reddit.com/r/neovim/comments/1bw5b35/helpautomatically_switching_neovim_theme_based_on/
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    opts = {
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
      end,
      update_interval = 3000,
      fallback = "dark",
    },
  },
}
