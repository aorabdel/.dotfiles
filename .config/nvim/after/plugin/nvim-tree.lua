---------
-- Keys
---------
--  <leader>e       Toggles the tree
--  g?              Shows all mapping (Inside vimTree)
--  TAB             Preview (Does not open a new tab)
--  R               Refresh
--  q               Close
--  
--  m               Toggle Bookmark
--  bmv             Move Bookmarked

--  <C-]>           CD
--  a               Creates a file or a dir(adding / at the end of the path)
--  d               delete a file/dir
--  D               Trash
--  r               Rename
--  y               Copy Name
--  Y               Copy Relative Path
--  c               Copy
--  x               Cut
--  p               Paste
--  gy              Copy Absolute Path
--  I               Toggle Git Ignore
--  -               Up
--  >               Next Sibling
--  .               Run Command
--  <               Previous Sibling

--  f               Filter
--  F               Clean Filter
--  
--  E               Expand all
--  W               Collapse all
--  U               Toggle hidden

local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
    return
end

-- recommended settings from documentation
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

nvimtree.setup({
    actions = {
        open_file = {
            window_picker = {
                enable = false
            },
        },
    },
    renderer = {
        indent_markers = { enable = true, },
        highlight_git = true,
        icons = {
            show = { git = true },
        },
    },
})

-- Open on Startup
-- vim.api.nvim_create_autocmd({"VimEnter"}, {
    -- callback = function() require("nvim-tree.api").tree.open() end,
-- })

-- Allows quitting if NvimTree was open
vim.api.nvim_create_autocmd({"QuitPre"}, {
    callback = function() vim.cmd("NvimTreeClose") end,
})
