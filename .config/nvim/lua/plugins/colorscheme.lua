return {
    -- Transparency
    {
		"xiyaowong/nvim-transparent",
		lazy = false,
		priority = 999,
	},
    -- Colorschemes
    { 
        "martinsione/darkplus.nvim",
        lazy = false,
        priority = 1000,
    },
    { 
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            contrast = "hard",
            transparent_mode = true,
        },
    },
    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.everforest_background = "hard"
            vim.g.everforest_ui_contrast = "high"
            vim.cmd.colorscheme("everforest")
        end,
    },
}
