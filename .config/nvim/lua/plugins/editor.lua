return {
    {
        "christoomey/vim-tmux-navigator",
    },
    {
        "szw/vim-maximizer",
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
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },  
            })
        end,
    },
    {
        'abecodes/tabout.nvim',
        config = function()
            require('tabout').setup {
                tabkey = '<Tab>',
                backwards_tabkey = '<S-Tab>',
                act_as_tab = true,
                act_as_shift_tab = true, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
                default_shift_tab = '<C-d>', -- reverse shift default action,
                enable_backwards = true, -- well ...
                completion = false, -- if the tabkey is used in a completion pum
                tabouts = {
                    { open = "'", close = "'" },
                    { open = '"', close = '"' },
                    { open = '`', close = '`' },
                    { open = '(', close = ')' },
                    { open = '[', close = ']' },
                    { open = '{', close = '}' }
                },
                ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
                exclude = {} -- tabout will ignore these filetypes
            }
        end,
        dependencies = { -- These are optional
            "nvim-treesitter/nvim-treesitter",
        },
        opt = true,  -- Set this to true if the plugin is optional
        event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
        priority = 1000,
    },
}
