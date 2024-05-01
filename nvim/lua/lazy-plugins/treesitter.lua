return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            auto_install = true,
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = nil,
            },
        })
    end,
}
