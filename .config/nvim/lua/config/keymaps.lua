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

-- paste register 0, yank saves to unnamed and register 0, d/c only saves to unnamed
keymap.set("n", "<leader>p", '"0p', opts)
keymap.set("n", "<leader>P", '"0P', opts)

-- Shift tab
keymap.set("i", "<S-TAB>", "<C-d>", opts)

-- Search and replace the word under the cursor
keymap.set("n", "<leader>h", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Search the word under the cursor
keymap.set("n", "<leader>sw", [[/<C-r><C-w>]])

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
keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
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

-- editor selection holding shift
keymap.set("n", "<S-UP>", "vk", opts)
keymap.set("n", "<S-DOWN>", "vj", opts)
keymap.set("i", "<S-UP>", "<ESC>vk", opts)
keymap.set("i", "<S-DOWN>", "<ESC>vj", opts)
keymap.set("x", "<S-UP>", "k", opts)
keymap.set("x", "<S-DOWN>", "j", opts)

-- cursor history

-- bufferline
keymap.set("n", "<A-RIGHT>", ":bnext<CR>", opts) -- next buffer
keymap.set("n", "<A-LEFT>", ":bprevious<CR>", opts) -- previous buffer
keymap.set("n", "<leader>q", ":update|bp|sp|bn|bd<CR>", opts) -- close buffer
keymap.set("n", "<leader>q", function()
	-- If buffer has a name and is modified, save it
	if vim.api.nvim_buf_get_name(0) ~= "" and vim.api.nvim_get_option_value("modified", { buf = 0 }) then
		vim.cmd("write")
	end
	-- Close the buffer
	vim.cmd("bd")
end, { desc = "Save and close buffer" })
keymap.set("n", "<leader>Q", function()
	vim.cmd("silent! wa") -- Save all named files, ignore errors
	vim.cmd("qa") -- Quit all
end, { desc = "Save all and quit" })
