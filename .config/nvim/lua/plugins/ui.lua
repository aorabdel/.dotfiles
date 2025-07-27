return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "wombat",
			},
			sections = {
				lualine_c = { { "filename", path = 3 } },
			},
		},
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		config = function()
			local dashboard = require("alpha.themes.dashboard")
			local art = vim.g.ascii_art
			local icons = vim.g.icons

			dashboard.section.header.val = art.krakedking_header
			dashboard.section.buttons.val = {
				dashboard.button("<leader>e", icons.ui.FindFile .. "  Find file", ":Telescope find_files <CR>"),
				dashboard.button("<leader>fb", icons.ui.List .. "  File browser", ":Telescope file_browser <CR>"),
				dashboard.button("<leader>fr", icons.ui.Files .. "  Recently used files", ":Telescope oldfiles <CR>"),
				dashboard.button("<leader>gr", icons.ui.FindText .. "  Find text", ":Telescope live_grep <CR>"),
				dashboard.button("e", icons.ui.NewFile .. "  New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
			}
			dashboard.section.footer.val = function()
				return "CWD: " .. vim.fn.getcwd()
			end

			dashboard.section.footer.opts.hl = "Type"
			dashboard.section.header.opts.hl = "Include"
			dashboard.section.buttons.opts.hl = "Keyword"

			dashboard.opts.opts.noautocmd = true

			require("alpha").setup(dashboard.config)
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			routes = {
				{
					view = "notify",
					filter = { event = "msg_showmode" },
				},
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			{
				"rcarriga/nvim-notify",
				opts = {
					timeout = 3000,
					render = "compact",
					top_down = false,
					background_colour = "#000000",
					fade_in_slide_out = true,
				},
			},
		},
	},
}
