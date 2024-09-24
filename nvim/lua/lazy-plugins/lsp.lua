-- rust-analyzer settings
local rust_analyzer = {
    target_dir = "target/rust_analyzer",
    -- override_cmd = { "cargo", "clippy", "--workspace", "--message-format=json" },
}

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            lspconfig.rust_analyzer.setup({
                -- remove this line if you have rust-analyzer installed by Mason
                cmd = { "rust-analyzer" },
                filetypes = { "rust" },
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            targetDir = rust_analyzer.target_dir,
                        },
                    },
                },
            })

            lspconfig.lua_ls.setup({
                -- remove this line if you have lua-language-server installed by Mason
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                capabilities = capabilities,
            })
        end,
    },
}
