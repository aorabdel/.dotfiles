local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- line wrapping
opt.wrap = false
opt.breakindent = true
opt.linebreak = true
opt.showbreak = "↳ "

-- behaviour
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.swapfile = false
opt.backup = false
opt.autochdir = false
opt.mouse = "a"
opt.mousemodel = "extend"
opt.hidden = true

-- search settings
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
-- opt.hlsearch = false

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.scrolloff = 10

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true
-- disable per split plane
opt.laststatus = 3

-- word matching
opt.iskeyword:append("-")

-- pop-up window height
opt.pumheight = 10

-- disable default status bar
opt.showmode = false

-- folds
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
