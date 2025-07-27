-- highlight on yank
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- project switching
local project_switching_group = vim.api.nvim_create_augroup("ProjectSwitchingGroup", {})
vim.api.nvim_create_autocmd("DirChanged", {
	group = project_switching_group,
	callback = function()
		vim.schedule(function()
			-- write and close all buffers
			vim.cmd("silent! wa")
			vim.cmd("silent! %bwipeout!")

			-- close all lsp clients
			vim.lsp.stop_client(vim.lsp.get_clients())

			-- open dashboard
			vim.cmd("Alpha")
		end)
	end,
})
