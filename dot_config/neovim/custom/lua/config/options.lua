vim.g.mapleader = " "
vim.g.localmapleader = "\\"

-- Providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Plugin related
vim.g.snacks_animate = true
vim.g.trouble_lualine = true

-- Neovim options
local opt = vim.opt

-- Release dependant
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
  opt.foldexpr = "v:lua.require'util'.ui.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.require'util'.ui.foldtext()"
end

-- Behavior
opt.autowrite = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.confirm = true
-- opt.formatexpr = "v:lua.require'util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.jumpoptions = "view"
opt.mouse = "nv"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.timeoutlen = 300
opt.updatetime = 200
opt.virtualedit = "block"

-- User interface
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.cursorline = false
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.laststatus = 3
opt.linebreak = true
opt.wrap = false
opt.list = true
opt.number = true
opt.relativenumber = true
opt.pumblend = 10
opt.pumheight = 10
opt.ruler = false
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.showmode = false
opt.signcolumn = "yes"
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.termguicolors = true
opt.winminwidth = 5

-- Search and replace
opt.smartcase = true
opt.ignorecase = true
opt.tagcase = "followscs"

opt.inccommand = "nosplit"

opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep --hidden -g !.git"
opt.wildmode = "longest:full,full"
opt.wildignore = {
  "**/node_modules/**", -- Node.js
  "**/coverage/**", -- ???
  "**/.idea/**", -- JetBrains IDE
  "**/.git/**", -- Git
  "**/.nuxt/**", -- Nuxt.js
  "**/target/**", -- Rust
}

-- tabs, shifts and indentation
opt.expandtab = true
opt.smarttab = true
opt.tabstop = 4
opt.softtabstop = 4

opt.autoindent = true
opt.smartindent = true

opt.shiftwidth = 4
opt.shiftround = true

-- Spelling
opt.spelllang = { "sv", "en" }

-- Data and backup
opt.directory = vim.fn.stdpath("config") .. "/.swap//"
opt.backupdir = vim.fn.stdpath("config") .. "/.backup//"
opt.undodir = vim.fn.stdpath("config") .. "/.undo//"
opt.swapfile = true
opt.backup = true
opt.undofile = true
