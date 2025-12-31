local autocmd = vim.api.nvim_create_autocmd

local function augroup(name) return vim.api.nvim_create_augroup("peario." .. name, { clear = true }) end

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
-- If don't do this on `FileType`, this keeps reappearing due to being set in
-- filetype plugins.
autocmd("FileType", {
  group = augroup("stop_autowrapping_comments"),
  pattern = "*",
  command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
  desc = [[Ensure comments don't auto-wrap, especially on use with 'o'.]],
})

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  pattern = "*",
  callback = function() (vim.hl or vim.highlight).on_yank({ timeout = 170 }) end,
})

autocmd("BufWinEnter", {
  group = augroup("clear_last_search"),
  pattern = "*",
  command = "let @/ = ''",
  desc = "Clear the last used search pattern",
})

-- Resize splits if window got resized
autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
-- autocmd("BufReadPost", {
--   group = augroup("last_loc"),
--   callback = function(event)
--     local exclude = { "gitcommit" }
--     local buf = event.buf
--     if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then return end
--     vim.b[buf].last_loc = true
--     local mark = vim.api.nvim_buf_get_mark(buf, '"')
--     local lcount = vim.api.nvim_buf_line_count(buf)
--     if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
--   end,
-- })

autocmd("BufWinEnter", {
  group = augroup("last_loc"),
  pattern = "*",
  command = [[ if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]],
  desc = "Jump to the last location when re-opening a file.",
})

autocmd("BufWritePre", {
  group = augroup("save_del_whitespace"),
  pattern = "*",
  command = "%s/\\s\\+$//e",
  desc = "Remove whitespaces on save.",
})

-- Close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event) vim.bo[event.buf].buflisted = false end,
})

autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd("FileType", {
  group = augroup("json_conceal"),
  pattern = {
    "json",
    -- "jsonc",
    "json5",
  },
  callback = function() vim.opt_local.conceallevel = 0 end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("filetype_help"),
  pattern = "*/doc/*.txt",
  callback = function() vim.bo.filetype = "help" end,
})

autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local map = vim.keymap.set
    local bs = { buffer = true, silent = true }
    local bsr = { buffer = true, remap = true, silent = true }

    map("n", "<C-c>", "<cmd>bd<CR>", bs)
    map("n", "<Tab>", "mf", bsr)
    map("n", "<S-Tab>", "mF", bsr)
    -- improved file creation
    map("n", "%", function()
      local dir = vim.b.netrw_curdir or vim.fn.expand("%:p:h")
      vim.ui.input({ prompt = "Enter filename: " }, function(input)
        if input and input ~= "" then
          local filepath = dir .. "/" .. input
          vim.cmd("!touch " .. vim.fn.shellescape(filepath))
          vim.api.nvim_feedkeys("<C-l>", "n", false)
        end
      end)
    end, { buffer = true, silent = true })
  end,
})

-- Append backup files with timestamp
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local extension = "~" .. vim.fn.strftime("%Y-%m-%d-%H%M%S")
    vim.o.backupext = extension
  end,
})

-- Automatic toggle between numbers and relative numbers depending on if the current mode is insert
local exclude_ft = { "qf" }
local rnu_augroup = augroup("toggle_relative_number")

--- Toggle relative numbers on
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  group = rnu_augroup,
  callback = function()
    if vim.tbl_contains(exclude_ft, vim.bo.filetype) then return end

    if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, "i") then vim.wo.relativenumber = true end
  end,
})

--- Toggle relative numbers off
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  group = rnu_augroup,
  callback = function(args)
    if vim.tbl_contains(exclude_ft, vim.bo.filetype) then return end

    if vim.wo.nu then vim.wo.relativenumber = false end

    -- Redraw here to avoid having to first write something for the line numbers to update.
    if args.event == "CmdlineEnter" then
      if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then vim.cmd.redraw() end
    end
  end,
})

-- Keymaps for `:`-mode
autocmd("CmdwinEnter", {
  group = augroup("cmdwin"),
  callback = function(args)
    local map = vim.keymap.set

    -- Execute command and stay in the command-line window
    map({ "n", "i" }, "<S-CR>", "<CR>q:", { buffer = args.buf })
    map("n", "q", ":q<CR>", { buffer = args.buf, nowait = true, silent = true })
  end,
})

-- Terminal
autocmd({ "TermOpen", "BufWinEnter", "WinEnter" }, {
  group = augroup("term_start_insert"),
  pattern = "term://*",
  callback = function() vim.cmd.startinsert() end,
})

-- Set CursorLine of not-current windows
local cursorline_nc = augroup("cursorline_nc")

autocmd({ "VimEnter", "WinEnter", "TabEnter", "BufEnter" }, {
  group = cursorline_nc,
  callback = function() vim.opt_local.winhighlight:remove("CursorLine") end,
})

autocmd("WinLeave", {
  group = cursorline_nc,
  callback = function() vim.opt_local.winhighlight:append({ CursorLine = "CursorLineNC" }) end,
})

-- Modification of hover and LSP features
-- https://www.reddit.com/r/neovim/comments/1mtktii/can_i_do_this_with_blinkts_ls_lsp/
autocmd("LspAttach", {
  pattern = "*",
  callback = function(args)
    ---@param mode string|string[]
    ---@param lhs string
    ---@param rhs string|function
    ---@param opts vim.keymap.set.Opts?
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.silent = opts.silent ~= true
      opts.noremap = opts.noremap ~= true

      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- stylua: ignore start
    map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, { desc = "Hover" })
    map("n", "gK", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, { buffer = args.buf, desc = "LSP Signautre help" })
    map("i", "<c-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, { buffer = args.buf, desc = "LSP Signautre help" })
    if vim.fn.exists(":FzfLua") then
      map("n", "gd", "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>", { desc = "Goto definition" })
      map("n", "gr", "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>", { desc = "References" })
      map("n", "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", { desc = "Goto implementation" })
      map("n", "gy", "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>", { desc = "Goto t[y]pe definition" })
    else
      map("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
      map("n", "gr", vim.lsp.buf.references, { desc = "References" })
      map("n", "gI", vim.lsp.buf.implementation, { desc = "Goto implementation" })
      map("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto t[y]pe definition" })
    end
    map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
    map({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run codelens" })
    map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & display codelens" })
    map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
    map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostics" })
    -- stylua: ignore end

    local ok_conform, conform = pcall(require, "conform")
    if ok_conform then
      -- Format buffer
      map(
        "n",
        "<leader>cf",
        function()
          conform.format({
            lsp_fallback = true,
            async = true,
            timeout_ms = 500,
          })
        end,
        { desc = "Format buffer (conform)" }
      )

      -- format range
      map(
        "v",
        "<leader>cf",
        function()
          conform.format({
            lsp_fallback = true,
            async = true,
            timeout_ms = 1000,
          })
        end,
        { desc = "Format range (conform)" }
      )
    else
      map("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format buffer" })
    end
  end,
})
