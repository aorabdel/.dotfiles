local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

vim.g.mapleader = " "

local keymap = vim.keymap

---------------------
-- General Keymaps
---------------------

--- TODO
-- search in github organizaiton
-- search project include Dependencies
-- live grep word under cursor
-- search in Workspace (all local projects)
-- git signs and git git_status
-- buffer - close others
-- find more telescope extensions

-- exit insert mode
keymap.set("i", "<C-c>", "<ESC>")
keymap.set("n", "<C-q>", "<C-v>")

-- save file
keymap.set("i", "<C-s>", "<ESC>:w<CR>", opts)
keymap.set("n", "<C-s>", ":w<CR>", opts)

-- select all
keymap.set("n", "<C-a>", "ggVG", opts)

-- paste register 0, yank saves to unnamed and register 0, d/c only saves to unnamed
keymap.set("n", "<leader>p", '"0p', opts)
keymap.set("n", "<leader>P", '"0P', opts)

-- Shift tab
keymap.set("i", "<S-TAB>", "<C-d>", opts)

-- Search and replace the word under the cursor
keymap.set("n", "<leader>h",[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Search the word under the cursor
keymap.set("n", "<leader>sw",[[/<C-r><C-w>]])

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
keymap.set("n", "<leader>\\", "<C-w>v", opts) -- split window vertically
keymap.set("n", "<leader>-", "<C-w>s", opts) -- split window horizontally
-- keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
keymap.set("n", "<leader>x", ":close<CR>", opts) -- close current split window

keymap.set("n", "<C-j>", "<C-w><C-j>", opts) -- move to below split window
keymap.set("n", "<C-k>", "<C-w><C-k>", opts) -- move to above split window
keymap.set("n", "<C-l>", "<C-w><C-l>", opts) -- move to right split window
keymap.set("n", "<C-h>", "<C-w><C-h>", opts) -- move to left split window

keymap.set("n", "<C-A-Left>", ":vertical resize +2<CR>", opts)
keymap.set("n", "<C-A-Right>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-A-UP>", ":horizontal resize +2<CR>", opts)
keymap.set("n", "<C-A-DOWN>", ":horizontal resize -2<CR>", opts)

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
keymap.set("n", "<leader>z", ":MaximizerToggle<CR>", opts) -- toggle split window maximization

-- nvim-tree, opts
-- keymap.set("n", "<leader>b", ":NvimTreeToggle<CR>", opts) -- toggle file explorer

-- telescope
keymap.set("n", "<leader>e", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>") -- file browser
keymap.set("n", "<leader>r", "<cmd>Telescope oldfiles<CR>") -- recent files
keymap.set("n", "<leader>gr", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
vim.keymap.set("n", "<leader>gp", function()
  require('telescope.builtin').live_grep({
    search_dirs = {vim.fn.system('go env GOPATH'):gsub('\n', '') .. '/pkg/mod'},
    prompt_title = 'Search Go Dependencies',
  })
end)
keymap.set("n", "<leader>gw", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>cs", "<cmd>Telescope colorscheme<cr>") 

-- telescope git commands
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gf", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- bufferline 
-- TODO: Maybe make A-Left, A-Right, instead of ctrl-i and ctrl-o
-- and make ctrl-n and ctrl-p bnext and bprev
keymap.set("n", "<A-RIGHT>", ":bnext<CR>", opts) -- next tab
keymap.set("n", "<A-LEFT>", ":bprevious<CR>", opts) -- previous tab
keymap.set("n", "<leader>q", ":update|bp|sp|bn|bd<CR>", opts) -- close tab
-- write all modified buffers and quit
keymap.set("n", "<leader>Q", ":xa<CR>")

keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", opts) -- close tab
