return {
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
                            targetDir = "target/rust_analyzer",
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
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettier,
                },
            })
        end,
    },
    {
        "tiyashbasu/refactor.nvim",
    },
    -- Commenting out Mason for NixOS compatibility,
    -- because the binaries it downloads are not compatible with NixOS.
    -- {
    --     "williamboman/mason.nvim",
    --     lazy = false,
    --     config = function()
    --         require("mason").setup()
    --     end,
    -- },
    -- {
    --     "williamboman/mason-lspconfig.nvim",
    --     lazy = false,
    --     opts = {
    --         auto_install = true,
    --     },
    -- },
}
