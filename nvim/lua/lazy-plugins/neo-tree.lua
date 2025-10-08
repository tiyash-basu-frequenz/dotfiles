return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    lazy = false,
    config = function()
        require("neo-tree").setup({
            source_selector = {
                winbar = true,
                statusline = true,
            },
            filesystem = {
                filtered_items = {
                    visible = true,
                },
            },
            use_libuv_file_watcher = true,
        })
    end,
}
