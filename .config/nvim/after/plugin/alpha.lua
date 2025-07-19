local setup, alpha = pcall(require, "alpha")
if not setup then
    return
end

local dashboard = require("alpha.themes.dashboard")
local art = vim.g.ascii_art
local icons = vim.g.icons

dashboard.section.header.val = art.krakedking_header 

dashboard.section.buttons.val = {
	dashboard.button("<leader>e", icons.ui.FindFile .. "  Find file", ":Telescope find_files <CR>"),
	dashboard.button("<leader>fb", icons.ui.List .. "  File browser", ":Telescope file_browser <CR>"),
	dashboard.button("<leader>fr", icons.ui.Files .. "  Recently used files", ":Telescope oldfiles <CR>"),
    dashboard.button("<leader>g", icons.ui.FindText .. "  Find text", ":Telescope live_grep <CR>"),
	dashboard.button("e", icons.ui.NewFile .. "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)

