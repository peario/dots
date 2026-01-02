--- Convenient shortened name for the function
local autocmd = vim.api.nvim_create_autocmd

--- Convenient function wrapper around creating augroups.
--- @param name string Name of the augroup
--- @param opts? { [string]: any } Options for the augroup
local function augroup(name, opts)
  name = name or "unnamed_augroup"
  opts = opts or { clear = true }

  vim.api.nvim_create_augroup(name, opts)
end

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- If don't do this on "FileType", this keeps reappearing due to being set in
-- filetype plugins.
autocmd("FileType", {
  desc = "Ensure comments don't auto-wrap, especially on use with 'o'.",
  group = augroup("stop_autowrapping_comments"),
  pattern = "*",
  command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Check if we need to reload the file when it changed.",
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

autocmd("TextYankPost", {
  desc = "Highlight text on yank (copy).",
  group = augroup("yank_highlight"),
  pattern = "*",
  callback = function()
    (vim.hl or vim.highlight).on_yank({ timeout = 170 })
  end,
})

autocmd("BufWinEnter", {
  desc = "Clear the last used search pattern.",
  group = augroup("clear_last_search"),
  pattern = "*",
  command = [[let @/ = '']],
})

autocmd("VimResized", {
  desc = "Resize splits if window got resized.",
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- autocmd("BufReadPost", {
--   desc = "Jump to the last cursor location when re-opening a file.",
--   group = augroup("last_loc"),
--   callback = function(event)
--     local exclude = { "gitcommit" }
--     local buf = event.buf
--     if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
--       return
--     end
--     vim.b[buf].last_loc = true
--     local mark = vim.api.nvim_buf_get_mark(buf, '"')
--     local lcount = vim.api.nvim_buf_line_count(buf)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })

autocmd("BufWinEnter", {
  desc = "Jump to the last cursor location when re-opening a file.",
  group = augroup("last_loc"),
  pattern = "*",
  -- TODO: maybe rewrite this to using lua callback?
  command = [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]],
})

autocmd("BufWritePre", {
  desc = "Remove whitespaces on save.",
  group = augroup("save_del_whitespace"),
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

autocmd("FileType", {
  desc = "Close some filetypes with <q>.",
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

autocmd("FileType", {
  desc = "Make it easier to close man-files when opened inline.",
  group = augroup("man_unlisted"),
  pattern = "man",
  callback = function()
    vim.bo[event.buf].buflisted = false
  end,
})

autocmd("FileType", {
  desc = "Enable spelling and wrapping in text files.",
  group = augroup("wrap_spell_in_text"),
  pattern = { "txt", "text", "plaintex", "tex", "typst", "gitcommit", "markdown" },
  callback = function(event)
    vim.bo[event.buf].wrap = true
    vim.bo[event.buf].spell = true
  end,
})

autocmd("FileType", {
  desc = "Correction of conceal level in JSON files.",
  group = augroup("json_conceal"),
  pattern = {
    "json",
    "json5",
    -- "jsonc",
  },
  callback = function(event)
    vim.bo[event.buf].conceallevel = 0
  end,
})

autocmd("BufWritePre", {
  desc = "Auto create directories when saving a file, in case some intermediate directory does not exist.",
  group = augroup("auto_create_dirs"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  desc = "Set the filetype of any textfile within a docs folder to 'help'.",
  group = augroup("filetype_help"),
  pattern = "*/doc/*.txt",
  callback = function()
    vim.bo.filetype = "help"
  end,
})

autocmd("FileType", {
  desc = "Setup keymaps for use within Netrw",
  group = augroup("netrw_keymaps"),
  pattern = "netrw",
  callback = function()
    local map = vim.keymap.set
    local bs = { buffer = true, silent = true }
    local bsr = { buffer = true, silent = true, remap = true }

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
    end, bs)
  end,
})

autocmd("BufWritePre", {
  desc = "Append backup files with timestamp.",
  group = augroup("append_backup_timestamp"),
  pattern = "*",
  callback = function()
    local extension = "~" .. vim.fn.strftime("%Y-%m-%d-%H%M%S")
    vim.opt.backupext = extension
  end,
})

-- Automatic toggle between relative and non-relative numbers depending on  if the current mode is insert or not.
local exclude_ft = { "qf" }
local rnu_augroup = augroup("toggle_relative_number")

autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  desc = "Toggle relative numbers on.",
  group = rnu_augroup,
  callback = function()
    if vim.tbl_contains(exclude_ft, vim.bo.filetype) then
      return
    end

    if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, "i") then
      vim.wo.relativenumber = true
    end
  end,
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  desc = "Toggle relative numbers off.",
  group = rnu_augroup,
  callback = function(args)
    if vim.tbl_contains(exclude_ft, vim.bo.filetype) then
      return
    end

    if vim.wo.nu then
      vim.wo.relativenumber = false
    end

    -- Redraw here to avoid having to first write something for the line numbers to update.
    if args.event == "CmdlineEnter" then
      if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then
        vim.cmd.redraw()
      end
    end
  end,
})

autocmd("CmdwinEnter", {
  desc = "Keymaps for `:`-mode",
  group = augroup("cmdwin_keymaps"),
  callback = function(event)
    local map = vim.keymap.set

    -- Execute command and stay in the command-line window
    map({ "n", "i" }, "<S-CR>", "<CR>q:", { buffer = event.buf })
    map("n", "q", ":q<CR>", { buffer = event.buf, nowait = true, silent = true })
  end,
})

autocmd({ "TermOpen", "BufWinEnter", "WinEnter" }, {
  desc = "Open Terminal in insert-mode",
  group = augroup("term_start_insert"),
  pattern = "term://*",
  callback = function()
    vim.cmd.startinsert()
  end,
})

-- Set CursorLine of not-current windows
local cursorline_nc = augroup("cursorline_nc")

autocmd({ "VimEnter", "WinEnter", "TabEnter", "BufEnter" }, {
  desc = "Hide the cursorline of the current window.",
  group = cursorline_nc,
  callback = function()
    vim.opt_local.winhighlight:remove("CursorLine")
  end,
})

autocmd({ "WinLeave" }, {
  desc = "Hide the cursorline of all non-active or non-selected windows.",
  group = cursorline_nc,
  callback = function()
    vim.opt_local.winhighlight:append({ CursorLine = "CursorLineNC" })
  end,
})

-- Source: https://www.reddit.com/r/neovim/comments/1mtktii/can_i_do_this_with_blinkts_ls_lsp/
autocmd("LspAttach", {
  desc = "Modifications of hover and LSP features.",
  pattern = "*",
  callback = function(event)
    local buf = event.buf

    --- @param mode string|string[]
    --- @param lhs string
    --- @param rhs string|function
    --- @param opts vim.keymap.set.Opts?
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.silent = opts.silent ~= true
      opts.norempa = opts.noremap ~= true

      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- stylua: ignore start
    map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, { desc = "Hover" })
    map("n", "gK", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, { desc = "LSP Signature help" })
    map("i", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, { desc = "LSP Signature help" })

    -- TODO: Change fzf to tv.
    -- if vim.fn.exists(":Tv") then
    --   map("n", "gd", "<cmd>Tv <cr>", { desc = "Goto definition" })
    --   map("n", "gr", "<cmd>Tv <cr>", { desc = "References" })
    --   map("n", "gI", "<cmd>Tv <cr>", { desc = "Goto implementation" })
    --   map("n", "gy", "<cmd>Tv <cr>", { desc = "Goto t[y]pe definition" })
    -- else
    if vim.fn.exists(":FzfLua") then
      map("n", "gd", "<cmd>FzfLua lua_definitions jump1=true ignore_current_line=true<cr>", { desc = "Goto definition" })
      map("n", "gr", "<cmd>FzfLua lua_references jump1=true ignore_current_line=true<cr>", { desc = "References" })
      map("n", "gI", "<cmd>FzfLua lua_implementations jump1=true ignore_current_line=true<cr>", { desc = "Goto implementation" })
      map("n", "gy", "<cmd>FzfLua lua_typedefs jump1=true ignore_current_line=true<cr>", { desc = "Goto t[y]pe definition" })
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
    map("n", "<leader>cd", vim.lsp.buf.open_float, { desc = "Show diagnostics" })

    -- Formatting
    local has_conform, conform = pcall(require, "conform")
    if has_conform then
      -- Format buffer
      map("n", "", function()
        conform.format({
          lsp_fallback = true,
          async = true,
          timeout_ms = 1000,
        })
      end, { desc = "Format buffer (conform)" })

      -- Format range
      map("v", "<leader>cf", function()
        conform.format({
          lsp_fallback = true,
          async = true,
          timeout_ms = 1000,
        })
      end, { desc = "Format range (conform)" })
    else
      map("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format buffer" })
    end
    -- stylua: ignore end
  end,
})

local pumheight_group = augroup("pumheight_cmdline")
autocmd("CmdlineEnter", {
  desc = "When performing a search, increase pop-up menu height.",
  group = pumheight_group,
  pattern = [[/\\?]],
  callback = function()
    vim.opt.pumheight = 8
  end,
})

autocmd("CmdlineLeave", {
  desc = "Once search is done, reset pop-up menu height.",
  group = pumheight_group,
  pattern = [[/\\?]],
  callback = function()
    -- Reset option to default value
    vim.opt.pumheight:remove()
  end,
})
