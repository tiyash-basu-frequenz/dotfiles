return {
    "numToStr/Comment.nvim",
    opts = {},
    lazy = false,
    config = function()
        require("Comment").setup({
            toggler = {
                line = "<M-/>",
                block = "gbc",
            },
            opleader = {
                line = "gc",
                block = "gb",
            },
        })
    end,
}
