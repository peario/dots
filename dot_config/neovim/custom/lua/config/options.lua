local options = {
  g = {
    -- Explicit providers
    loaded_ruby_provider = 0,
    loaded_perl_provider = 0,
    loaded_node_provider = 0,
    -- For snippets
    loaded_python3_provider = 1
  },
  opt = {
    -- Behavior
    autowrite = true,
    history = 3000,
    backspace = "eol,start,indent",
    clipboard = vim.env.SSH_TTY and "" or "unnamedplus",
    completeopt = "menu,menuone,noselect",
    encoding = "utf-8",
    splitbelow = true,
    splitright = true,
    splitkeep = "screen",
    timeoutlen = 300,
    updatetime = 200,
    virtualedit = "block",
    mouse = "nv",
    spell = false,
    spelllang = { "sv", "en" },
    confirm = true,
    formatoptions = "jcroqlnt", -- tcqj
    jumpoptions = "view",
    sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
    
    -- Look and feel
    termguicolors = vim.fn.has("termguicolors") == 1,
    number = true,
    relativenumber = false,
    cursorline = false,
    signcolumn="yes",
    ruler = false,
    wrap = false,
    linebreak = true,
    textwidth = 500,
    conceallevel = 2,
    foldlevel = 0,
    foldlevelstart = 99,
    foldmethod = "indent",
    showmode = false,
    pumheight = 10,
    pumblend = 10,
    scrolloff = 4,
    sidescrolloff = 8,
    winminwidth = 5,
    laststatus = 2,
    list = true,
    fillchars = {
      foldopen = "",
      foldclose = "",
      fold = " ",
      foldsep = " ",
      diff = "╱",
      eob = " ",
    },

    -- Searching
    smartcase = true,
    ignorecase = true,
    infercase = true,
    tagcase = "followscs",
    hlsearch = true,
    incsearch = true,
    wildmenu = true,
    wildmode = "longest:full,full",
    -- wildignore = { },

    grepformat = "%f:%l:%c:%m",
    grepprg = [[rg --vimgrep --no-heading --smart-case --hidden --follow --trim ]]
      .. [[--glob '!.git/*' --glob '!node_modules/*' --glob '!.cache/*' ]]
      .. [[--glob '!dist/*' --glob '!coverage/*' --glob '!*.min.*' ]],

    -- Indentations, tabs and shifts
    autoindent = true,
    smartindent = true,
    smarttab = true,

    expandtab = true,
    tabstop = 2,
    softtabstop = 2,

    shiftround = true,
    shiftwidth = 2,

    -- Data, undo and backup
    backupdir = vim.fn.stdpath("state") .. "/backup",
    directory = vim.fn.stdpath("state") .. "/swap",
    undodir = vim.fn.stdpath("state") .. "/undo",

    backup = false,
    swapfile = false,
    undolevels = 10000,
  },
}

-- apply options above
--
-- vim.[ set ].[ key ] = [ value ]
for set, scope in pairs(options) do
  for key, value in pairs(scope) do
    vim[set][key] = value
  end
end

-- For options which could not be set via the format above
local opt = vim.opt

opt.shortmess:append({ W = true, I = true, c = true, C = true })
