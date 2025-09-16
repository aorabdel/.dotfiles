return {
	{ -- Main LSP Setup
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"whoissethdaniel/mason-tool-installer.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("keymaps-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "lsp: " .. desc })
					end

					local function telescope_lsp(picker)
						return function()
							require("telescope.builtin")[picker]({ layout_strategy = "vertical" })
						end
					end

					-- Diagnostics function with vertical layout
					local function telescope_diagnostics_sorted()
						local diagnostics =
							vim.diagnostic.get(nil, { severity = { min = vim.diagnostic.severity.HINT } })
						table.sort(diagnostics, function(a, b)
							return a.severity < b.severity
						end)
						require("telescope.builtin").diagnostics({
							bufnr = nil,
							diagnostics = diagnostics,
							layout_strategy = "vertical",
						})
					end

					-- keymaps
					map("gd", telescope_lsp("lsp_definitions"), "[g]oto [d]efinition")
					map("gr", telescope_lsp("lsp_references"), "[g]oto [r]eferences")
					map("gi", telescope_lsp("lsp_implementations"), "[g]oto [i]mplementation")
					map("gs", telescope_lsp("lsp_document_symbols"), "open document symbols")
					map("gS", telescope_lsp("lsp_dynamic_workspace_symbols"), "open workspace symbols")
					map("gt", telescope_lsp("lsp_type_definitions"), "[g]oto [t]ype definition")
					map("ga", telescope_diagnostics_sorted, "[g]oto [a]nalysis")
					map("gD", vim.lsp.buf.declaration, "[g]oto [d]eclaration")
					map("gR", vim.lsp.buf.rename, "[r]e[n]ame")
					map("gc", vim.lsp.buf.code_action, "[g]oto code [a]ction", { "n", "x" })

					-- highlight references on cursor hold
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "cursorhold", "cursorholdi" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "cursormoved", "cursormovedi" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("lspdetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end
				end,
			})

			-- LSP Server configuration
			local servers = {
				gopls = {
					root_dir = function(_, on_dir)
						on_dir(vim.fn.getcwd())
					end,
					settings = {
						gopls = {
							-- enable all analyses
							analyses = {
								unusedparams = true,
								shadow = true,
								nilness = true,
								unusedwrite = true,
								useany = true,
								ST1000 = false, -- Disable ST1000 package comment check
							},
							-- enable experimental features
							experimentalpostfixcompletions = true,
							gofumpt = true,
							staticcheck = true,
							useplaceholders = true,
							-- completeunimported = true,
							matcher = "fuzzy",
							symbolmatcher = "fuzzy",
							-- this is crucial for cross-package functionality
							buildflags = { "-tags=integration" },
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "luajit" },
							workspace = {
								checkthirdparty = false,
								library = vim.api.nvim_get_runtime_file("", true),
							},
							format = {
								enable = false,
							},
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
			}

			-- use mason-tool-installer to install lsp servers
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
                "goimports",
                "gofumpt",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- setup automatic enabling of lsp clients
			require("mason-lspconfig").setup({
				automatic_enable = vim.tbl_keys(servers or {}),
			})

			-- setup each LSP server
			-- capabilities get added automatically by `blink-cmp` to all configs
			for server_name, config in pairs(servers) do
				vim.lsp.config(server_name, config)
			end
		end,
	},
	{ -- Inline diagnostics
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			local icons = vim.g.icons.diagnostics
			vim.diagnostic.config({
				underline = false,
				virtual_text = false,
				update_in_insert = false,
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.BoldError,
						[vim.diagnostic.severity.WARN] = icons.BoldWarning,
						[vim.diagnostic.severity.HINT] = icons.BoldHint,
						[vim.diagnostic.severity.INFO] = icons.BoldInformation,
					},
				},
			})

			require("tiny-inline-diagnostic").setup({
				preset = "powerline",
			})
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"gf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 3000,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
                go = {"goimports", "gofumpt"},
			},
		},
	},
}
