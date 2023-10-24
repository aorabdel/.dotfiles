local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

vim.g.mapleader = " "

local keymap = vim.keymap

---------------------
-- General Keymaps
---------------------

-- exit insert mode
keymap.set("i", "<C-c>", "<ESC>")
keymap.set("n", "<C-q>", "<C-v>")

-- save file
keymap.set("i", "<C-s>", "<ESC>:w<CR>", opts)
keymap.set("n", "<C-s>", ":w<CR>", opts)

-- select all
keymap.set("n", "<C-a>", "ggVG", opts)

-- Shift tab
keymap.set("i", "<S-TAB>", "<C-d>", opts)

-- Search and replace the word under the cursor
keymap.set("n", "<leader>h",[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Search the word under the cursor
keymap.set("n", "<leader>s",[[/<C-r><C-w>]])

-- disable macro recording
keymap.set("n", "Q", "<nop>")

-- put cursor on the start of the line after joining lines
keymap.set("n", "J", "mzJ`z")

-- center cursor after jumping half page
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- clear search highlights
keymap.set("n", "<leader>ch", ":nohl<CR>", opts)

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

keymap.set("n", "<C-j>", "<C-w><C-j>") -- move to below split window
keymap.set("n", "<C-k>", "<C-w><C-k>") -- move to above split window
keymap.set("n", "<C-l>", "<C-w><C-l>") -- move to right split window
keymap.set("n", "<C-h>", "<C-w><C-h>") -- move to left split window

keymap.set("n", "<C-A-Left>", ":vertical resize +2<CR>")
keymap.set("n", "<C-A-Right>", ":vertical resize -2<CR>")
keymap.set("n", "<C-A-UP>", ":horizontal resize +2<CR>")
keymap.set("n", "<C-A-DOWN>", ":horizontal resize -2<CR>")

keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>" ,opts) -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Stay in indent mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Move text up and down
keymap.set("n", "<A-UP>", ":m .-2<CR>==", opts)
keymap.set("n", "<A-DOWN>", ":m .+1<CR>==", opts)
keymap.set("x", "<A-UP>", ":move '<-2<CR>gv-gv", opts)
keymap.set("x", "<A-DOWN>", ":move '>+1<CR>gv-gv", opts)

---------------------
-- PLugins Keymaps
---------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>") -- file browser
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>") -- recent files
keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>c", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>cs", "<cmd>Telescope colorscheme<cr>") 

-- telescope git commands
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- bufferline 
keymap.set("n", "<A-RIGHT>", ":bnext<CR>", opts) -- next tab
keymap.set("n", "<A-LEFT>", ":bprevious<CR>", opts) -- previous tab
keymap.set("n", "<C-w>", ":bp|sp|bn|bd<CR>", opts) -- close tab
