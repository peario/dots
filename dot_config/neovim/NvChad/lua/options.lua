-- For convenience ============================================================
local opt = vim.opt

--- Check if running inside WSL (Windows Subsystem for Linux)
--- @return boolean True if in WSL, false otherwise
local function is_wsl()
  return vim.uv.os_uname().release:lower():find("microsoft") ~= nil and vim.fn.has("wsl") == 1
end

--- Check if running inside an SSH session.
--- @return boolean True if inside active SSH session, false otherwise
local function is_ssh()
  return vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil
end

-- General and globals ========================================================

-- if vim.fn.exists("syntax_on") ~= 1 then
--   vim.cmd("syntax enable")
-- end
--
-- vim.cmd("filetype plugin indent on")

vim.g.markdown_folding = 1

-- Behavior ===================================================================

opt.autowrite = true
opt.history = 2000
-- don't stop backspace at insert
-- opt.backspace = "eol,start,indent"
opt.backspace = vim.list_extend(vim.opt.backspace:get(), { "nostop" })

-- unsetting clipboard and then setting it within a `vim.schedule(...)`
-- lowers startup time.
opt.clipboard = ""
vim.schedule(function()
  -- Sync with system clipboard
  opt.clipboard = is_ssh() and "" or "unnamedplus"
end)

if is_wsl() then
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end

local completeopt = "menuone,noselect"
if vim.fn.has("nvim-0.11") == 1 then
  completeopt = completeopt .. ",fuzzy" -- ",nosort"
end
opt.completeopt = completeopt

opt.encoding = "utf-8"
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- TODO: add explanation of what this is, what each option does, how it
--       differs from LazyVim's (append WICc).
opt.shortmess = "CFOSWaco"

if vim.fn.has("nvim-0.11") == 1 then
  -- go to the last used tab when closing the current tab
  opt.tabclose = "uselast"
end

opt.switchbuf = "usetab"
-- the higher the number of ms, the more time to press keybind combinations
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.updatetime = 100
opt.redrawtime = 1500
opt.virtualedit = "block"
opt.mouse = "nv"
opt.spell = false
opt.spelllang = "sv,en"
opt.spelloptions = "camel"

-- use spell check and don't use tags for completion
opt.complete = ".,w,b,kspell"
opt.confirm = true
-- opt.formatoptions = "jcroqlnt" -- tcqj
opt.formatoptions = "rqnl1j"
opt.jumpoptions = "view"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- UI (look and feel) =========================================================

opt.numberwidth = 2
opt.number = true
-- disabled for the `number_toggle` augroup, see autocmds.lua
opt.relativenumber = false

opt.termguicolors = true
opt.signcolumn = "yes"
opt.colorcolumn = "+1"
opt.ruler = false
opt.whichwrap:append("<>[]hl")
opt.wrap = false
opt.linebreak = true -- If wrap is enabled, make it look nice at least
opt.textwidth = 500
opt.conceallevel = 2

opt.foldtext = ""
opt.foldmethod = "indent"
opt.foldlevel = 99
-- opt.foldnextmax = 10
-- opt.foldlevelstart = 99

-- pum = pop-up menu
opt.pumblend = 0 -- pseudo-transparency
-- opt.pumheight = 10 -- max numbers of items to show in pum
opt.pummaxwidth = 100 -- max width for pum, 0 = no limit

if vim.fn.has("nvim-0.12") == 1 then
  -- require("vim._extui").enable({})

  opt.wildmenu = true
  opt.wildmode = "longest:full,full"
  opt.wildoptions = "pum,fuzzy"
  opt.wildignore = { "**/node_modules/**" }

  -- Move these to `keymaps.lua`
  local map = vim.keymap.set

  map("c", "<Up>", "<C-u><Up>")
  map("c", "<Down>", "<C-u><Down>")

  -- Set wildcharm to a hidden key (e.g., Ctrl-z)
  opt.wildcharm = 26 -- This is the internal code/char code for <C-z>
  map("c", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<C-z>"]], { expr = true })
  map("c", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
end

-- Make background transparent
-- vim.cmd([[
--   highlight Normal guibg=none
--   highlight NonText guibg=none
--   highlight Normal ctermbg=none
--   highlight NonText ctermbg=none
-- ]])

opt.showmode = false
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.winminwidth = 5
opt.laststatus = 3 -- for statusline
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

-- Show cursor line only when screen is wrapped.
opt.cursorline = true
opt.cursorlineopt = "screenline,number"
opt.breakindentopt = "list:-1" -- Add padding for lists when 'wrap' is on
opt.showbreak = "󱞩 "

-- Searching ==================================================================

opt.smartcase = true
opt.infercase = true
opt.ignorecase = true
opt.tagcase = "followscs"

opt.hlsearch = false
opt.incsearch = true
opt.inccommand = "nosplit"

-- Treat characters '@', '_' and '-' in words as part of a whole word text object
opt.iskeyword = "@,48-57,_,192-255,-"

-- Define patern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed by some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

opt.grepprg = [[rg --vimgrep --no-heading --smart-case --hidden --follow --trim ]]
.. [[ --glob '!.git/*' --glob '!node_modules/*' --glob '!.cache/*' --glob '!target/*' ]]
.. [[ --glob '!dist/*' --glob '!coverage/*' --glob '!debug/*' --glob '!*.min.*' ]]
.. [[ --glob '!.venv/*' ]]
opt.grepformat = "%f:%l:%c:%m"

-- Indentation, tab & shifts ==================================================

opt.breakindent = true
opt.copyindent = true -- copy the previous indentation on auto-indent
opt.preserveindent = true

opt.autoindent = true
opt.smartindent = true
opt.smarttab = true

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2

opt.shiftround = true
opt.shiftwidth = 2

-- Data, undo & backup ========================================================

local backup_dir = vim.fn.stdpath("data") .. "/.cache"

opt.directory = backup_dir .. "/swap"
opt.backupdir = backup_dir .. "/backup"
opt.undodir = backup_dir .. "/undo"
opt.viewdir = backup_dir .. "/view"

opt.backup = true
opt.backupcopy = "yes"
opt.writebackup = true
opt.swapfile = true
opt.undofile = false
opt.undolevels = 10000

-- opt.shada = "'100,<50,210,:1000,/100,@100"
opt.shada = "'100,<50,f50,n" .. backup_dir .. "/shada/shada"
