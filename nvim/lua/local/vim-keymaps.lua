-- quit
vim.keymap.set("n", "<C-q>", ":q<CR>", {})

-- save
vim.keymap.set("n", "<C-s>", ":w<CR>", {})
vim.keymap.set("i", "<C-s>", function()
    vim.api.nvim_command("write")
    vim.api.nvim_command("startinsert")
end, {})

-- shortcuts - neotree
vim.keymap.set("n", "<C-b>", ":Neotree filesystem reveal left<CR>", {})

-- shortcuts - telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

-- shortcuts - LSP
-- https://neovim.io/doc/user/lsp.html
vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, {})
vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float({ scope = "line" })
end, { desc = "Show diagnostics for current line" })

-- Inlay Hints
vim.keymap.set("n", "<C-k>", function()
    if vim.lsp.inlay_hint.is_enabled() then
        vim.lsp.inlay_hint.enable(false)
    else
        vim.lsp.inlay_hint.enable(true)
    end
end, { desc = "Toggle Inlay Hints" })

-- shortcuts - git
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})

-- shortcuts - refactor
local refactor = require("refactor")
vim.keymap.set("n", "<F3>", function()
    refactor.text_replace_word()
end, {})
vim.keymap.set("v", "<F3>", function()
    refactor.text_replace_selection()
end, {})
vim.keymap.set("n", "<F2>", function()
    refactor.lsp_rename_symbol()
end, {})
