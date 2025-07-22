vim.opt.background = "dark"
vim.g.everforest_background = "hard"
-- vim.g.everforest_disable_italic_comment = true
vim.g.everforest_ui_contrast = "high"

-- local status, _ = pcall(vim.cmd, "colorscheme darkplus")
local status, _ = pcall(vim.cmd, "colorscheme everforest")
if not status then
    print("Color scheme not found!")
    return
end
