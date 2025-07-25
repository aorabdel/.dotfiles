return {
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    {
        "szw/vim-maximizer",
        lazy = false,
        keys = {
            { "<leader>z", "<cmd>MaximizerToggle<CR>" ,  desc = "toggle window maximization" },
        },
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },
    {
        'numToStr/Comment.nvim',
        lazy = false,
        opts = {
            --- toggle mappings in NORMAL mode
            toggler = {
                line = '<C-_>',
                block = 'gb',
            },
            --- toggle mappings in VISUAL mode
            opleader = {
                line = '<C-_>',
                block = 'gb',
            },
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        lazy = false,
        main = "ibl",
        opts = {
            indent = {
                -- char = '│',  -- Default thick line
                char = '┊',  -- Dotted line (thinnest)
                -- char = '╎',  -- Dashed line
                -- char = '┆',  -- Thin dotted
                -- char = '⋮',  -- Vertical ellipsis
            },
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
        config = function () 
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { 
                    "c", "cpp", "python", "go", "gomod", "gosum", "gotmpl", "gowork",
                    "vim", "vimdoc", "lua",
                    "javascript", "html", "css",
                    "bash", "awk", "tmux", "regex",
                    "dockerfile", "json", "yaml"
                },
                sync_install = false,
                auto_install = false,
                highlight = { enable = true },
                indent = { enable = true },  
            })
        end,
    },
}