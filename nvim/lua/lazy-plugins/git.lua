return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        config = true
    }
}
