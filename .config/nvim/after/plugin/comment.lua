local setup, comment = pcall(require, "Comment")
if not setup then
    return
end

comment.setup({
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        line = '<C-_>',
        block = 'gb',
    },
    ---LHS of toggle mappings in VISUAL mode
    opleader = {
        line = '<C-_>',
        block = 'gb',
    }
})
