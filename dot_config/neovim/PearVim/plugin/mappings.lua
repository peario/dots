vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = function(mode, lhs, rhs, opts)
  mode = mode or "n"
  lhs = lhs or ""
  opts = opts or {}

  vim.keymap.set(mode, lhs, rhs, opts)
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Scroll up and down with centering
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (with zz)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (with zz)" })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { desc = "Escape and Clear hlsearch", expr = true })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { desc = "Next Search Result", expr = true })
map({ "x", "o" }, "n", "'Nn'[v:searchforward]", { desc = "Next Search Result", expr = true })
map("n", "N", "'nN'[v:searchforward].'zv'", { desc = "Prev Search Result", expr = true })
map({ "x", "o" }, "N", "'nN'[v:searchforward]", { desc = "Prev Search Result", expr = true })

-- Add undo break-points
-- map({ ",", ",<c-g>u", mode = "i" })
-- map({ ".", ".<c-g>u", mode = "i" })
-- map({ ";", ";<c-g>u", mode = "i" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w!<cr><esc>", { desc = "Save file" })
map("n", "<leader>fs", "<cmd>w!<cr>", { desc = "Save file" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })

-- Location list
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- Quickfix list
map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.jump({ count = 1, float = true })
    or vim.diagnostic.jump({ count = -1, float = true })

  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    if go ~= nil then
      go({ severity = severity })
    end
  end
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", function()
  diagnostic_goto(true)
end, { desc = "Next Diagnostic" })
map("n", "[d", function()
  diagnostic_goto(false)
end, { desc = "Prev Diagnostic" })
map("n", "]e", function()
  diagnostic_goto(true, "ERROR")
end, { desc = "Next Error" })
map("n", "[e", function()
  diagnostic_goto(false, "ERROR")
end, { desc = "Prev Error" })
map("n", "]w", function()
  diagnostic_goto(true, "WARN")
end, { desc = "Next Warning" })
map("n", "[w", function()
  diagnostic_goto(false, "WARN")
end, { desc = "Prev Warning" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>qr", "<cmd>restart<cr>", { desc = "Restart" })

-- highlights udner cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
-- TODO: Verify that this is the correct mode!
map("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, { desc = "Inspect Tree" })

-- Terminal mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<C-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
map("t", "<Esc>", "<C-\\><C-N>", { desc = "Exit Terminal" })

-- windows
map("n", "<leader>-", "<C-w>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-w>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete Window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- native snippets. nvim version < 0.11 required
map("s", "<Tab>", function()
  return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
end, { desc = "Jump Next", expr = true })
map({ "i", "s" }, "<S-Tab>", function()
  return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
end, { desc = "Jump Previous", expr = true })

-- Netrw
-- map("n", "<leader>fe", "<cmd>Lexplore %:p:h<CR>", { desc = "File browser" })
-- map("n", "<leader>e", "<cmd>Lexplore %:p:h<CR>", { desc = "File browser" })
