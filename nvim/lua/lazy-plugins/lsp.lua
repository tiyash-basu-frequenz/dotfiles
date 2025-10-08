return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Configure gopls
            vim.lsp.config("gopls", {
                cmd = { "gopls" },
                filetypes = { "go" },
                root_markers = { "go.mod", "go.work", ".git" },
                capabilities = capabilities,
            })

            -- Configure lua_ls
            vim.lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
                capabilities = capabilities,
            })

            -- Configure rust_analyzer
            vim.lsp.config("rust_analyzer", {
                cmd = { "rust-analyzer" },
                filetypes = { "rust" },
                root_markers = { "Cargo.toml", "rust-project.json", ".git" },
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            targetDir = "target/rust_analyzer",
                        },
                        diagnostics = {
                            enable = true,
                        },
                        imports = {
                            granularity = {
                                group = "module",
                            },
                            prefix = "self",
                        },
                    },
                },
            })

            -- Configure protols
            vim.lsp.config("protols", {
                cmd = { "protols" },
                root_markers = { ".git" },
            })

            -- Enable all configured LSP servers
            vim.lsp.enable("gopls")
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("rust_analyzer")
            vim.lsp.enable("protols")
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
                    null_ls.builtins.diagnostics.codespell,
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
