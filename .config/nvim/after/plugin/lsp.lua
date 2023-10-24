local setup, mason = pcall(require, "mason")
if not setup then
    return
end

local setup, mason_lspconfig = pcall(require, "mason-lspconfig")
if not setup then
    return
end

local setup, lspconfig = pcall(require, "lspconfig")
if not setup then
    return
end

local servers = { 'clangd' }

mason.setup()
mason_lspconfig.setup({
    ensure_installed = servers,
})

local lspconfig_parameters = {}
local setup, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if setup then
    -- Add additional capabilities supported by nvim-cmp
    lspconfig_parameters.capabilities = cmp_nvim_lsp.default_capabilities()
end

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup(lspconfig_parameters)
end


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gs', "<cmd>ClangdSwitchSourceHeader<cr>", opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>cf', function()
            vim.lsp.buf.format { async = true }
        end, opts)

        local setup, telescope_builtin = pcall(require, "telescope.builtin")
        if setup then
            vim.keymap.set('n', '<leader>D', telescope_builtin.lsp_type_definitions, opts)
            vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, opts)
            vim.keymap.set('n', 'gls', telescope_builtin.lsp_document_symbols, opts)
        else
            vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', 'gls', vim.lsp.buf.document_symbols, opts)
        end
    end,
})