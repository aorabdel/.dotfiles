return {
    -- Transparency
    {
		"xiyaowong/nvim-transparent",
		priority = 999,
	},
    -- Colorschemes
    { 
        "martinsione/darkplus.nvim",
        priority = 1000,
    },
    { 
        "EdenEast/nightfox.nvim",
        priority = 1000,
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        opts = {
            contrast = "hard",
            transparent_mode = true,
        },
    },
    {
        "sainnhe/everforest",
        priority = 1000,
        config = function()
            vim.g.everforest_background = "hard"
            vim.g.everforest_ui_contrast = "high"
            vim.cmd.colorscheme("everforest")
        end,
    },
}
