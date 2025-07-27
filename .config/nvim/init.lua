require("config.lazy")

--- TODO ---
-- search in github organizaiton
-- search project include Dependencies
-- search in Workspace (all local projects)
-- git signs and git git_status
-- buffer - close others
-- find more telescope extensions
--      Configuration Recipes - https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
--      Extensions - https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions
-- plugins and public .dotfiles - https://dotfyle.com/
-- Maybe make A-Left, A-Right, instead of ctrl-i and ctrl-o and make ctrl-n and ctrl-p bnext and bprev
-- folke nvim repos - https://github.com/folke?tab=repositories&q=nvim
-- https://www.youtube.com/watch?v=fhrP6YHAvzI  //  https://github.com/radleylewis/nvim
-- Noice - configure - search overrides lualine
-- bottom margin under status
-- Checkout out all telescope_builtin.lsp_* functions
-- Checkout out all vim.lsp.* functions
-- setup snippets
--      Luasnip (engine)
--      setup snippets - friendly-snippets (library)
--      include it in blink.cmp

--- DONE
-- Fix: live grep word under cursor (set correct options to ignore .gitignore and search hidden files)
-- lsp quircks (mimic vs-code behaviour)
--     * ON LspRestart, the auto dispatcher will create a new default lsp client, that means no settings, and no specific setup
--     * gopls quirk: if you do a go mod tidy, Imports diagnostic will only update when the imports are edited, any other edits than the imports,
--       does not refresh the diagnostics regarding imports
--     * if there are multiple go buffers open from different packages, you will have multiple lsp clients and they will clash with eachother, especially if they are dependencies,
--       you will see errors like function not found in the depencies and dependancy walking will be broken, make sure you have only one gopls client and make sure it is for the desired root dir

--- Motions ---
-- <count>r - replace next <count> char with input char and go back to Normal mode
-- D - delete till end of line
-- 0D - delete entire line and stay in Normal mode
-- s - delete char and go to insert mode
-- S - delete entire line and go to insret mode
