local setup, autopair = pcall(require, "nvim-autopairs")
if not setup then
    return
end

autopair.setup()
