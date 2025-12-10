-- quit
vim.keymap.set("n", "<C-q>", ":q<CR>", { desc = "Quit" })

-- save
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })
vim.keymap.set("i", "<C-s>", function()
    vim.api.nvim_command("write")
    vim.api.nvim_command("startinsert")
end, {})

-- tab navigation
-- see https://neovim.io/doc/user/tabpage.html
vim.keymap.set("n", "<leader>tt", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tr", ":-tabnext<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>ty", ":+tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>te", ":-tabmove<CR>", { desc = "Move tab right" })
vim.keymap.set("n", "<leader>tu", ":+tabmove<CR>", { desc = "Move tab left" })

-- shortcuts - neotree
vim.keymap.set("n", "<C-b>", ":Neotree filesystem reveal left<CR>", { desc = "Open file browser" })

-- shortcuts - telescope
-- see https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "Jump list" })

-- shortcuts - LSP
-- https://neovim.io/doc/user/lsp.html
vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "Show references" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format code" })
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
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview git hunk" })

-- shortcuts - refactor
local refactor = require("refactor")
vim.keymap.set("n", "<leader>rw", refactor.text_replace_word, { desc = "Replace word" })
vim.keymap.set("v", "<leader>rw", refactor.text_replace_selection, { desc = "Replace selection" })
vim.keymap.set("n", "<leader>rs", refactor.lsp_rename_symbol, { desc = "Rename symbol" })

-- shortcuts - Copilot
vim.g.copilot_no_tab_map = true
vim.keymap.set("i", "<C-Space>", "copilot#Accept(\"\\<CR>\")", {
    expr = true,
    replace_keycodes = false,
    desc = "Accept Copilot suggestion",
})
vim.keymap.set("i", "<C-]>", "copilot#AcceptWord()", {
    expr = true,
    replace_keycodes = false,
    desc = "Accept next word from Copilot suggestion",
})
