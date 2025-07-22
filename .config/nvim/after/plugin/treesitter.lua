local setup, ts_config = pcall(require, "nvim-treesitter.configs")
if not setup then
    return
end

ts_config.setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "bash", "cpp", "c", "python", "lua", "vim", "vimdoc", "query", "go", },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },

    indent = { enable = true }
})
