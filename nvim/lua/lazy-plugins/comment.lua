return {
    "numToStr/Comment.nvim",
    opts = {},
    lazy = false,
    config = function()
        require("Comment").setup({
            toggler = {
                line = "<C-/>",
                block = "gbc",
            },
            opleader = {
                line = "<C-S-/>",
                block = "gb",
            },
        })
    end,
}
