local M = {}

-- Bootstrap lazy.nvim
local lazypath = vim.env.LAZY or vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazyversion = "--branch=stable"

if not (vim.env.LAZY or vim.uv.fs_stat(lazypath)) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    lazyversion, -- e.g. `--branch=stable`
    lazyrepo,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- options should be loaded before lazy.nvim
require("config.options")
require("util.plugin").setup_lazy_file()

---@param opts LazyConfig
function M.load(opts)
  opts = vim.tbl_deep_extend("force", {
    ---@type LazySpec
    spec = {
      { import = "plugins" },
    },
    install = {
      colorscheme = { "onenord", "tokyonight", "habamax" },
    },
    diff = { cmd = "terminal_git" },
    checker = {
      enabled = true,
      notify = true,
    },
    change_detection = { enabled = true },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          -- "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    debug = false,
  }, opts or {})

  -- Make sure lazy.nvim is present and loadable
  local ok, lazy = pcall(require, "lazy")
  if not ok then
    vim.api.nvim_echo({
      { ("Unable to load lazy.nvim from: %s\n"):format(lazypath), "ErrorMsg" },
      { "\nPress any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end

  -- Setup lazy.nvim
  lazy.setup(opts)

  -- Load autocmds, options, keymaps, etc.
  require("config.autocmds")
  require("config.keymaps")
end

return M
