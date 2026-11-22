return {
	{
		"christoomey/vim-tmux-navigator",
	},
	{
		"szw/vim-maximizer",
		keys = {
			{ "<leader>z", "<cmd>MaximizerToggle<CR>", desc = "toggle window maximization" },
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			--- toggle mappings in NORMAL mode
			toggler = {
				line = "<C-_>",
				block = "gb",
			},
			--- toggle mappings in VISUAL mode
			opleader = {
				line = "<C-_>",
				block = "gb",
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			scope = {
				show_start = false,
			},
			indent = {
				-- char = '│',  -- Default thick line
				char = "┊", -- Dotted line (thinnest)
				-- char = '╎',  -- Dashed line
				-- char = '┆',  -- Thin dotted
				-- char = '⋮',  -- Vertical ellipsis
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
			{ "nvim-treesitter/nvim-treesitter-context", opts = {} },
		},
		config = function()
			local ts = require("nvim-treesitter")

			ts.install({
				"c",
				"cpp",
				"python",
				"go",
				"gomod",
				"gosum",
				"gotmpl",
				"gowork",
				"vim",
				"vimdoc",
				"lua",
				"javascript",
				"html",
				"css",
				"bash",
				"awk",
				"regex",
				"dockerfile",
				"json",
				"yaml",
				"markdown",
				"markdown_inline",
			})

			-- highlight + indent (replaces `highlight`/`indent`), and auto-install missing parsers (replaces `auto_install`)
			local function start(buf)
				vim.treesitter.start(buf)
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					if pcall(start, args.buf) then
						return
					end
					local lang = vim.treesitter.language.get_lang(args.match)
					if lang and vim.tbl_contains(ts.get_available(), lang) then
						ts.install(lang):await(function()
							vim.schedule(function()
								if vim.api.nvim_buf_is_valid(args.buf) then
									pcall(start, args.buf)
								end
							end)
						end)
					end
				end,
			})

			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
				},
			})

			local keymaps = {
				-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#built-in-textobjects

				-- You can use the capture groups defined in textobjects.scm
				["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
				["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
				["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
				["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

				-- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
				["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
				["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
				["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
				["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },

				["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
				["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

				["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
				["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

				["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
				["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

				["ac"] = { query = "@call.outer", desc = "Select outer part of a function call" },
				["ic"] = { query = "@call.inner", desc = "Select inner part of a function call" },

				["af"] = {
					query = "@function.outer",
					desc = "Select outer part of a method/function definition",
				},
				["if"] = {
					query = "@function.inner",
					desc = "Select inner part of a method/function definition",
				},

				["at"] = { query = "@class.outer", desc = "Select outer part of a class" },
				["it"] = { query = "@class.inner", desc = "Select inner part of a class" },
			}
			for lhs, map in pairs(keymaps) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					require("nvim-treesitter-textobjects.select").select_textobject(map.query, "textobjects")
				end, { desc = map.desc })
			end
		end,
	},

	{
		"abecodes/tabout.nvim",
		config = function()
			require("tabout").setup({
				tabkey = "<Tab>",
				backwards_tabkey = "<S-Tab>",
				act_as_tab = true,
				act_as_shift_tab = true, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
				default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
				default_shift_tab = "<C-d>", -- reverse shift default action,
				enable_backwards = true, -- well ...
				completion = false, -- if the tabkey is used in a completion pum
				tabouts = {
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = "`", close = "`" },
					{ open = "(", close = ")" },
					{ open = "[", close = "]" },
					{ open = "{", close = "}" },
				},
				ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
				exclude = {}, -- tabout will ignore these filetypes
			})
		end,
		dependencies = { -- These are optional
			"nvim-treesitter/nvim-treesitter",
		},
		opt = true, -- Set this to true if the plugin is optional
		event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
		priority = 1000,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
}
