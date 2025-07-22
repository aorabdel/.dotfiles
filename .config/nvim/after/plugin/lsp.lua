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

local function safe_map(mode, lhs, rhs, opts)
  if rhs == nil then
    vim.notify(("🛑 keymap %s %s has a NIL rhs!"):format(mode, lhs), vim.log.levels.ERROR)
    return
  end
  local ok, err = pcall(vim.keymap.set, mode, lhs, rhs, opts)
  if not ok then
    vim.notify(("🛑 mapping %s %s failed: %s"):format(mode, lhs, err), vim.log.levels.ERROR)
  end
end

-- write up on the quirks of LSP attack with mason-lspconfig
-- * ON LspRestart, the auto dispatcher will create a new default lsp client, that means no settings, and no specific setup
-- * gopls quirk: if you do a go mod tidy, Imports diagnostic will only update when the imports are edited, any other edits than the imports,
--   does not refresh the diagnostics regarding imports
-- * if there are multiple go buffers open from different packages, you will have multiple lsp clients and they will clash with eachother, especially if they are dependencies,
--   you will see errors like function not found in the depencies and dependancy walking will be broken, make sure you have only one gopls client and make sure it is for the desired root dir
local on_attach = function(client, buf)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    --
    -- TODO:
    -- - Checkout out all telescope_builtin.lsp_* functions
    -- - Checkout out all vim.lsp.* functions
    --
    local opts = { buffer = buf }
    safe_map('n', 'gD', vim.lsp.buf.declaration, opts)
    safe_map('n', 'gd', vim.lsp.buf.definition, opts)
    safe_map('n', 'gs', "<cmd>ClangdSwitchSourceHeader<cr>", opts)
    safe_map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    safe_map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    safe_map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    safe_map('n', '<leader>rn', vim.lsp.buf.rename, opts)
    safe_map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    safe_map('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    safe_map('n', '<leader>cf', function()
        vim.lsp.buf.format { async = true }
    end, opts)

    local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
    if has_telescope then
        safe_map('n', '<leader>D', telescope_builtin.lsp_definitions, opts)
        safe_map('n', 'gls', telescope_builtin.lsp_document_symbols, opts)
        safe_map('n', 'gr', telescope_builtin.lsp_references, opts)
        safe_map('n', 'gi', telescope_builtin.lsp_implementations, opts)
    else
        safe_map('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        safe_map('n', 'gi', vim.lsp.buf.implementation, opts)
        safe_map('n', 'gr', vim.lsp.buf.references, opts)
        safe_map('n', 'gls', vim.lsp.buf.document_symbols, opts)
    end
end

local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
)

local custom_gopls_handler = function(server_name, config)
    vim.notify("gopls handler")
end

mason.setup()
mason_lspconfig.setup({
    ensure_installed = { 'gopls' },
    automatic_enable = {
        exclude = { 'gopls', },
    },
})

local setup, lspconfigUtil = pcall(require, "lspconfig.util")
if not setup then
    vim.notify("could not import utils")
end

-- vim.api.nvim_create_autocmd("BufReadPost", {
--     group = vim.api.nvim_create_augroup("GoExternalMods", { clear = true }),
--   pattern = { "*.go" },
--   callback = function(ev)
--         vim.notify("autocommand run")
--     -- walk up until you find a go.mod
--     local pkg_root = lspconfigUtil.search_ancestors(ev.file, function(path)
--       if lspconfigUtil.path.is_file(path .. "/go.mod") then
--         return path
--       end
--     end)
--     if not pkg_root then
--       return
--     end
--     vim.notify("added to workspace", pkg_root)
--     -- add that module root to the current gopls workspace
--     vim.lsp.buf.add_workspace_folder(pkg_root)
--   end,
-- })

lspconfig.gopls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,

    -- root_dir = function(fname)
    --     result = lspconfigUtil.root_pattern("go.mod", ".git")
    --     vim.notify("added to ws ", result)
    -- end,

    -- settings = {
    --     gopls = {
    --         -- Enable all analyses
    --         analyses = {
    --             unusedparams = true,
    --             shadow = true,
    --             nilness = true,
    --             unusedwrite = true,
    --             useany = true,
    --         },
    --         -- Enable experimental features
    --         experimentalPostfixCompletions = true,
    --         gofumpt = true,
    --         staticcheck = true,
    --         usePlaceholders = true,
    --         -- completeUnimported = true,
    --         matcher = "Fuzzy",
    --         symbolMatcher = "fuzzy",
    --         -- This is crucial for cross-package functionality
    --         buildFlags = {"-tags=integration"},
    --     },
    -- },
}


