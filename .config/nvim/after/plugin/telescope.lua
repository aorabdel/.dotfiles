-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
    return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
    return
end

-- configure telescope
telescope.setup({
    pickers = {
        colorscheme = { enable_preview = true },
        find_files = { hidden = true },
        live_grep = {
            additional_args = function(opts)
                return {"--hidden"}
            end
        }
    },
    defaults = {
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                ["<C-j>"] = actions.move_selection_next, -- move to next result
                ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
                ["<ESC>"] = actions.close,
            },
        },
        sorting_strategy = 'ascending',
        layout_config = {
            horizontal = {
                prompt_position='top',
            },
        },
        file_ignore_patterns = {
            ".git/", ".cache", "%.o", "%.a", "%.out", "%.class",
		    "%.pdf", "%.mkv", "%.mp4", "%.zip"
        },
    },
    extensions = {
        file_browser = {
            hijack_netrw = true,
            hidden = { file_browser = true, folder_browser = true },
        },
    },
})

telescope.load_extension("fzf")
telescope.load_extension("file_browser")
