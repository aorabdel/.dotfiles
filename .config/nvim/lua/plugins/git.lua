return {
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            current_line_blame = true,
            attach_to_untracked = true,
        },
    },
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>dc", "<cmd>DiffviewOpen<cr>", desc = "[D]iff [C]urrent" },
            { "<leader>db", "<cmd>DiffviewOpen origin/main..HEAD<cr>", desc = "[D]iff [B]ranch" },
            { "<leader>dp", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle the [D]iff file [P]anel" },
            { "<leader>df", "<cmd>DiffviewFileHistory %<cr>", desc = "[D]iff [F]ile history" },
            { "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "[D]iff [Q]uit" },
        }
    },
}
