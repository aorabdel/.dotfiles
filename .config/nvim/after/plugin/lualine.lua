local status, lualine = pcall(require, "lualine")
if not status then
    return
end

lualine.setup({
    options = {
        -- theme = "codedark"
        theme = "auto"
    },
    sections = {
        lualine_c = { { 'filename', path = 3 } }
    }
})
