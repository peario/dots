-- stylua: ignore start
-- Leader keys ================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- General ====================================================================




-- UI ==========================================================================
vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1"

-- Explicitly set providers for faster startup
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

-- netrw (NERDtree style)
vim.g.netrw_banner = 0 -- Hide banner
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 3
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25 -- change size of netrw window when it creates a split
vim.g.netrw_keepdir = 0 -- keep current dir and browsing dir synced
vim.g.netrw_localcopydircmd = "cp -r" -- enable recursive copying of directories
-- vim.g.netrw_sort_by = "type"

-- Options
local opt = vim.opt

-- Behavior
opt.shell = "zsh"
opt.autowrite = true
opt.history = 2000
-- opt.backspace = "eol,start,indent"
opt.backspace = vim.list_extend(vim.opt.backspace:get(), { "nostop" }) -- don't stop backspace at insert
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- sync with system clipboard

if vim.fn.has("nvim-0.11") == 1 then
  opt.completeopt = "menuone,noselect,fuzzy,nosort"
else
  opt.completeopt = "menuone,noselect"
end

opt.encoding = "utf-8"
opt.splitbelow = true
opt.splitright = true

if vim.fn.has("nvim-0.9") == 1 then
  opt.shortmess = "CFOSWaco"
  opt.splitkeep = "screen"
end

if vim.fn.has("nvim-0.11") then
  opt.tabclose = "uselast" -- go to the last used tab when closing the current tab
end

opt.switchbuf = "usetab"
opt.timeoutlen = 500 -- the higher the number of ms, the more time to press keybinds-combinations
opt.ttimeoutlen = 10
opt.updatetime = 100
opt.redrawtime = 1500
opt.virtualedit = "block"
opt.mouse = "a"
opt.spell = false
opt.spelllang = "sv,en"
opt.spelloptions = "camel"
opt.complete = ".,w,b,kspell" -- use spell check and don't use tags for completion
opt.confirm = true
-- o.formatoptions = "jcroqlnt" -- tcqj
opt.formatoptions = "rqnl1j"
opt.jumpoptions = "view"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shortmess = "FOSWaco"
-- o.shortmess:append({ W = true, I = true, c = true, C = true })

-- Look and feel
opt.numberwidth = 2
opt.number = true
opt.relativenumber = false -- disabled for the `number_toggle` augroup, see ./lua/configs/autocmds.lua

opt.termguicolors = true -- default on Neovim >= 0.10
opt.signcolumn = "yes"
opt.colorcolumn = "+1"
opt.cursorline = false
opt.ruler = false
opt.wrap = false
opt.linebreak = true -- If wrap is enabled, make it look nice
opt.breakindent = true
opt.copyindent = true -- copy the previous indentation on auto-indent
opt.preserveindent = true -- preserve indent as much as possible
opt.textwidth = 500
opt.conceallevel = 2

opt.foldmethod = "indent"
opt.foldlevel = 0
-- opt.foldnextmax = 10
opt.foldlevelstart = 99
vim.g.markdown_folding = 1

if vim.fn.has("nvim-0.10") == 1 then
  opt.foldtext = ""
end

if vim.fn.has("nvim-0.12") == 1 then
  opt.pumheight = 10
  opt.pummaxwidth = 100
  -- opt.completefuzzycollect = "keyword,files,whole_line"

  require("vim._extui").enable({})

  -- increase pum height when performing a search
  --  `pumheight` = maximum amount of items in the popup menu
  --  so when searching, set max amount of items in the popup menu to 8
  vim.cmd([[autocmd CmdlineEnter [/\?] set pumheight=8]])
  vim.cmd([[autocmd CmdlineLeave [/\?] set pumheight&]])

  -- when only one match left in search, quietly auto-complete the match
  vim.cmd([[autocmd CmdlineChanged [:/\?@] call wildtrigger()]])
  opt.wildmenu = true
  opt.wildmode = "longest:full,full"
  opt.wildoptions = "pum,fuzzy"
  opt.wildignore = { "**/node_modules/**" }

  local map = vim.keymap.set
  map("c", "<Up>", "<C-u><Up>")
  map("c", "<Down>", "<C-u><Down>")

  map("c", "<Tab>", [[cmdcomplete_info().pum_visible ? "\<C-n>" : "\<Tab>"]], { expr = true })
  map("c", "<S-Tab>", [[cmdcomplete_info().pum_visible ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
end

-- Make background transparent
-- NOTE: Only works if the terminal itself has background set to transparent
vim.cmd([[
highlight Normal guibg=none
highlight NonText guibg=none
highlight Normal ctermbg=none
highlight NonText ctermbg=none
]])

opt.showmode = false
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.winminwidth = 5
opt.laststatus = 3 -- For statusline
opt.winborder = "rounded"

opt.list = true
-- opt.listchars = { -- Special text symbols
--   eol = " ",
--   extends="…",
--   multispace="|   ",
--   nbsp="␣",
--   precedes="…",
--   tab = "󰌒 ",
--   trail = "·",
-- }
opt.fillchars = { -- Special UI symbols
  -- source: LazyVim
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
  -- source: unknown
  horiz="═",
  horizdown="╦",
  horizup="╩",
  vert="║",
  verthoriz="╬",
  vertleft="╣",
  vertright="╠",
}
opt.cursorlineopt = "screenline,number" -- Show cursor line only screen line when wrapped
opt.breakindentopt = "list:-1" -- Add padding for lists when 'wrap' is on
opt.showbreak = "󱞩 "

-- Searching
opt.smartcase = true
opt.infercase = true
opt.ignorecase = true
opt.tagcase = "followscs"

opt.hlsearch = false
opt.incsearch = true
opt.inccommand = "nosplit"

opt.iskeyword = "@,48-57,_,192-255,-" -- treat dash separated words as a word text object

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

opt.grepprg = [[rg --vimgrep --no-heading --smart-case --hidden --follow ]]
.. [[ --glob '!.git/*' --glob '!node_modules/*' --glob '!.cache/*' ]]
.. [[ --glob '!dist/*' --glob '!coverage/*' --glob '!*.min.*' --trim ]]
opt.grepformat = "%f:%l:%c:%m"

-- Indentation, tab and shifts
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2

opt.shiftround = true
opt.shiftwidth = 2

-- Data, undo and backup
local backup_dir = vim.fn.stdpath("data") .. "/.cache"

opt.directory = backup_dir .. "/swap"
opt.backupdir = backup_dir .. "/backup"
opt.undodir = backup_dir .. "/undos"
opt.viewdir = backup_dir .. "/view"

opt.backup = true
opt.backupcopy = "yes"
opt.writebackup = true
opt.swapfile = true
opt.undofile = false
opt.undolevels = 10000

-- opt.shada = "'100,<50,210,:1000,/100,@100,h"
opt.shada = "'100,<50,f50,n" .. backup_dir .. "/shada/shada"

if vim.fn.exists("syntax_on") ~= 1 then
  vim.cmd("syntax enable")
end

vim.cmd("filetype plugin indent on")
