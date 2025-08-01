local opt = vim.opt

-- Behavior
opt.autowrite = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true
opt.formatoptions = "jcroqlnt"
opt.mouse = "nv"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.timeoutlen = 300
opt.updatetime = 200
opt.virtualedit = "block"
opt.selection = "old"
opt.wildmode = "longest:full,full"
opt.wildmenu = true
opt.shortmess = vim.tbl_deep_extend("force", vim.opt.shortmess:get(), { s = true, I = true, c = true, C = true })
opt.whichwrap:append("<>[]hl")
opt.tabclose = "uselast"
opt.backspace = vim.list_extend(vim.opt.backspace:get(), { "nostop" })
opt.breakindent = true
opt.title = true
opt.mousescroll = "ver:1,hor:0"
opt.autochdir = true

-- User interface
opt.conceallevel = 2
opt.cursorline = true
opt.cursorlineopt = "number"
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "1"
opt.laststatus = 3
opt.linebreak = true
opt.wrap = false
opt.list = true
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.ruler = false
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.showmode = false
opt.signcolumn = "yes"
opt.termguicolors = true
opt.winminwidth = 5
opt.smoothscroll = true
opt.diffopt = vim.list_extend(vim.opt.diffopt:get(), { "algorithm:histogram", "linematch:60" })

-- Tabs / indents / shifts
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4

opt.shiftround = true
opt.shiftwidth = 4

opt.smartindent = true
opt.copyindent = true
opt.preserveindent = true

-- Search & replace
opt.smartcase = true
opt.ignorecase = true
opt.infercase = true
opt.inccommand = "nosplit"

opt.jumpoptions = "view"

opt.grepformat = "%f:%l:%c:%m"
opt.grepprg =
  [[rg --vimgrep --no-heading --smart-case --hidden --follow --trim ]] ..
  [[--glob "!.git/*" --glob "!node_modules/*" --glob "!.cache/*" ]] ..
  [[--glob "!dist/*" --glob "!coverage/*" --glob "!*.min.*" ]] ..
  [[--glob "!*.map" --glob "!target/*"]]

-- Spelling
opt.spelllang = { "sv", "en" }

-- Swap, backup and undo
opt.shada = "!,'1000,<50,s10,h" -- Remember the last 1000 opened files
opt.history = 1000

opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000

opt.backupdir = vim.fn.stdpath("state") .. "/.backup"
opt.undodir = vim.fn.stdpath("state") .. "/.undo"
opt.directory = vim.fn.stdpath("state") .. "/.swap"

