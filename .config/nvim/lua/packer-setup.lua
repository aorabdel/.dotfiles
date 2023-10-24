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

    -- Color Schemes
    use("sainnhe/everforest")
    use('martinsione/darkplus.nvim')
    use('morhetz/gruvbox') 

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
    use("nvim-tree/nvim-tree.lua")

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

    -- Autocompletion
    use {
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        "L3MON4D3/LuaSnip",
        'onsails/lspkind.nvim',
    }

    use { 'kdheepak/lazygit.nvim' }

    if packer_bootstrap then
        require("packer").sync()
    end
end)
