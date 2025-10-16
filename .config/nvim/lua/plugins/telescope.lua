return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	-- branch = '1.1.x',
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-file-browser.nvim",
		"jvgrootveld/telescope-zoxide",
	},
	keys = {
        -- stylua: ignore start
		{ "<leader>e", "<cmd>Telescope find_files<cr>", desc = "find files within current working directory, respects .gitignore", },
		{ "<leader>fb", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "file browser" },
		{ "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "recent files" },
		{ "<leader>gr", "<cmd>Telescope live_grep<cr>", desc = "find string in current working directory as you type", },
		{ "<leader>gp", function()
				require("telescope.builtin").live_grep({
					prompt_title = "Search Go Dependencies",
					search_dirs = { vim.fn.system("go env GOPATH"):gsub("\n", "") .. "/pkg/mod" },
				})
			end,
			desc = "Search Go packages that are locally installed",
		},
		{ "<leader>gw", "<cmd>Telescope grep_string<cr>", desc = "find string under cursor in current working directory", },
		{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "list open buffers in current neovim instance" },
		{ "<leader>tr", "<cmd>Telescope resume<cr>", desc = "resume whatever telescope command was last opened" },
		{ "<leader>*", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "fuzzy find inside currently opened buffer" },
		{ "<leader>cs", "<cmd>Telescope colorscheme<cr>", desc = "list colorschemes" },
        { "<leader>fz", "<cmd>Telescope zoxide list<cr>", desc = "use zoxide list to change working directory" },

		-- telescope git commands
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "list all git commits (use <cr> to checkout) ['gc' for git commits]", },
		{ "<leader>gf", "<cmd>Telescope git_bcommits<cr>", desc = "list git commits for current file/buffer (use <cr> to checkout) ['gfc' for git file commits]", },
		{ "<leader>gl", "<cmd>Telescope git_bcommits_range<cr>", mode={ "n", "v" }, desc = "list git commits for current selected range (use <cr> to checkout) ['gfc' for git file commits]", },
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "list git branches (use <cr> to checkout) ['gb' for git branch]", },
		{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "list current changes per file with diff preview ['gs' for git status]", },
		-- stylua: ignore end
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
						["<ESC>"] = actions.close,
					},
				},
				sorting_strategy = "ascending",
                wrap_results = true,
				layout_config = {
					horizontal = {
						prompt_position = "top",
					},
				},
				file_ignore_patterns = {
					"^.git/",
					"^.cache",
					"%.o$",
					"%.a$",
					"%.out$",
					"%.class$",
					"%.pdf$",
					"%.mkv$",
					"%.mp6$",
					"%.zip$",
				},
			},
			pickers = {
				colorscheme = { enable_preview = true },
				find_files = {
					hidden = true,
					no_ignore = true,
				},
				live_grep = {
					additional_args = function(_)
						return { "--hidden", "--no-ignore" }
					end,
				},
				grep_string = {
					additional_args = function(_)
						return { "--hidden", "--no-ignore" }
					end,
				},
				current_buffer_fuzzy_find = {
					layout_strategy = "vertical",
					previewer = false,
					layout_config = {
						vertical = {
							prompt_position = "top",
						},
					},
				},
                lsp_document_symbols = {
                    symbol_width = 100
                },
                lsp_workspace_symbols = {
                    fname_width = 120
                },
			},
			extensions = {
				file_browser = {
					hijack_netrw = true,
					hidden = { file_browser = true, folder_browser = true },
				},
			},
		})

		-- Load extensions after setup
		telescope.load_extension("fzf")
		telescope.load_extension("file_browser")
		telescope.load_extension("zoxide")
	end,
}
