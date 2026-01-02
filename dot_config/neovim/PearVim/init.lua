-- Profiler - MUST BE AT THE TOP
local uv = vim.uv or vim.loop
---@type { label: string, elapse: number, block: number }[]
local marks = { }
local T_start = uv.hrtime()

local function mark(label, t0)
  local block = (uv.hrtime() - t0) / 1e6        -- timing: current "do ... end"-block
  local elapse = (uv.hrtime() - T_start) / 1e6  -- timing: start -> now
  marks[#marks + 1] = { label = label, block = block, elapse = elapse }
end

-- Register the dump to happen exactly when you quit
vim.api.nvim_create_autocmd("VimLeavePre", {
  once = true,
  callback = function()
    local out = {
      "-------------------------------------------------------------",
      "| ELAPSE      | BLOCK       | EVENT                         |",
      "-------------------------------------------------------------",
    }
    for _, m in ipairs(marks) do
      out[#out+1] = string.format("| %-12s| %-12s| %s", string.format("%4.3f ms", m.elapse), string.format("%4.3f ms", m.block), string.format("%-30s|", m.label))
    end

    local t_block = 0 ---@type float
    for _, m in ipairs(marks) do
      t_block = t_block + m.block
    end

    -- Add total time at the end
    -- local block_ms = (marks[#marks].block - uv.hrtime()) / 1e6
    local elapse_ms = (uv.hrtime() - T_start) / 1e6
    out[#out + 1] = "-------------------------------------------------------------"
    out[#out + 1] = ("| %-12s| %-12s| %-31s|"):format(string.format("%6.3f ms ", elapse_ms), string.format("%6.3f ms  ", t_block), "TOTAL")
    out[#out + 1] = "-------------------------------------------------------------"

    vim.fn.writefile(out, "/tmp/pearvim-profile.txt")
  end,
})

mark("START", uv.hrtime())

-- Bytecode cache
if vim.loader then
  vim.loader.enable(true)
end

-- Explicitly set providers for faster startup
do
  local t0 = uv.hrtime()

  vim.g.loaded_node_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_python_provider = 0
  vim.g.loaded_python3_provider = 0

  mark("1. Pre-set providers", t0)
end

-- Load options, autocmds, usercmds and keymaps (the order is important)
do
  local t0 = uv.hrtime()
  require("pear.options")
  mark("2. Require options", t0)
end

do
  local t0 = uv.hrtime()
  require("pear.autocmds")
  mark("3. Require autocmds", t0)
end

do
  local t0 = uv.hrtime()
  require("pear.usercmds")
  mark("4. Require usercmds", t0)
end

do
  local t0 = uv.hrtime()
  require("pear.keymaps")
  mark("5. Require keymaps", t0)
end

-- Setup Lazy.nvim
do
  local t0 = uv.hrtime()

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.comn/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

  mark("6. Bootstrap Lazy.nvim", uv.hrtime())
end

do
  local t0 = uv.hrtime()

  require("lazy").setup({
    defaults = { lazy = true },
    spec = {
      { import = "pear.plugins" },
    },
    install = { colorscheme = { "catppuccin" } },
    diff = {
      cmd = "terminal_git",
    },
    checker = { enabled = true },
    change_detection = {
      enabled = true,
      notify = true, -- switch to false later on once everything is setup.
    },
    performance = {
      cache = { enabled = true },
      rtp = {
        ---@type string[]
        paths = {},
        ---@type string[] List any plugins you want to disable here
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "netrw",
          "tarPlugin",
          "tar",
          "tohtml",
          "tutor",
          "2to3",
          "zipPlugin",
          "zip",
          "indent_blankline",
          "getscriptPlugin",
          "getscript",
          "vimballPlugin",
          "vimball",
        },
      },
    },
    -- Enable profiling of lazy.nvim. This will add some overhead,
    -- so only enable this when you are debugging lazy.nvim
    profiling = {
      -- Enables extra stats on the debug tab related to the loader cache.
      -- Additionally gathers stats about all package.loaders
      loader = false,
      -- Track each new require in the Lazy profiling tab
      require = false,
    },
  })

  mark("7. Require/setup Lazy.nvim", t0)
end
