-- auto install packer if not installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer-setup.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- add list of plugins to install
return packer.startup(function(use)

    -- packer itself
    use("wbthomason/packer.nvim") 
    
    -- lua functions that many plugins use
    use("nvim-lua/plenary.nvim")

    -- Transparency
    use {"xiyaowong/transparent.nvim", priority = 9999}
    -- Color Schemes
    use "sainnhe/everforest"
    use 'martinsione/darkplus.nvim'
    use 'morhetz/gruvbox'
    use "EdenEast/nightfox.nvim"

    use('ThePrimeagen/vim-be-good')

    -- tmux navigator
    use('christoomey/vim-tmux-navigator')

    -- Maximize/Minimize split windows
    use("szw/vim-maximizer")
    
    -- add, delete, change surroundings (it's awesome)
    use("tpope/vim-surround")

    -- replace with register contents using motion (gr + motion)
    use("inkarkat/vim-ReplaceWithRegister") 
    
    -- commenting with gc
    use("numToStr/Comment.nvim")

    -- file explorer
    -- use("nvim-tree/nvim-tree.lua")

    -- file icons
    use("nvim-tree/nvim-web-devicons")

    -- bufferline
    -- use({'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'})

    -- status line
    use("nvim-lualine/lualine.nvim")
    
    -- fuzzy finding w/ telescope
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder
    use { "nvim-telescope/telescope-file-browser.nvim", requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" } }

    -- Shows indentation lines
    use("lukas-reineke/indent-blankline.nvim") 

    -- Auto match braces and branckets
    use("windwp/nvim-autopairs") 
    
    -- Code syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

    -- Dashboard
    use("goolord/alpha-nvim")

    -- LSP
    -- Make sure 'zip' is installed - 'sudo apt install zip'
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }
    use {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = "LspAttach",
        priority = 1000,
        config = function()
            vim.diagnostic.config({
                underline = false,
                virtual_text = false,
                update_in_insert = false,
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                    }
                },
            })
            require("tiny-inline-diagnostic").setup({
                preset = "powerline",
            })
        end,
    }

    use {
        "lewis6991/hover.nvim",
        config = function()
            require("hover").setup {
                init = function()
                    -- Require providers
                    require("hover.providers.lsp")
                    -- require('hover.providers.gh')
                    -- require('hover.providers.gh_user')
                    -- require('hover.providers.jira')
                    -- require('hover.providers.dap')
                    -- require('hover.providers.fold_preview')
                    -- require('hover.providers.diagnostic')
                    -- require('hover.providers.man')
                    -- require('hover.providers.dictionary')
                    -- require('hover.providers.highlight')
                end,
                preview_opts = {
                    border = 'rounded'
                },
                -- Whether the contents of a currently open hover window should be moved
                -- to a :h preview-window when pressing the hover keymap.
                preview_window = false,
                title = true,
                mouse_providers = {
                    'LSP'
                },
                mouse_delay = 1000
            }

            -- Setup keymaps
            vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
            vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
            vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, {desc = "hover.nvim (previous source)"})
            vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, {desc = "hover.nvim (next source)"})

            -- Mouse support
            vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
            vim.o.mousemoveevent = true
        end,
    }
    -- Autocompletion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'saadparwaiz1/cmp_luasnip'
    use "L3MON4D3/LuaSnip"
    use "onsails/lspkind.nvim"
    use "kkharji/sqlite.lua" 
    use { 'samiulsami/cmp-go-deep', requires = { "kkharji/sqlite.lua" } }

    use { 'kdheepak/lazygit.nvim' }

    -- Noice - Experimental
    use {
    "folke/noice.nvim",
    -- lazy‑load on VimEnter (you can pick your own event)
    event = "VimEnter",
    requires = {
        "MunifTanjim/nui.nvim",
        {
            "rcarriga/nvim-notify",
            config = function()
                require("notify").setup({
                    timeout           = 3000,
                    render            = "compact",
                    top_down          = false,
                    background_colour = "#000000",
                    fade_in_slide_out = true,
                })
            end,
        },
    },
    config = function()
        require("noice").setup({
            routes = {
                {
                    view   = "notify",
                    filter = { event = "msg_showmode" },
                },
            },

            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"]               = true,
                    ["cmp.entry.get_documentation"]                 = true,
                },
            },

            presets = {
                bottom_search      = true,  -- classic bottom cmdline for / ?
                command_palette    = true,  -- position cmdline & popupmenu together
                long_message_to_split = true,
                inc_rename         = false,
                lsp_doc_border     = false,
            },
        })
    end,
    }

    if packer_bootstrap then
        require("packer").sync()
    end
end)
