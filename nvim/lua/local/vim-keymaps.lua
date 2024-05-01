-- quit
vim.keymap.set("n", "<C-q>", ":q<CR>", {})

-- save
vim.keymap.set("n", "<C-s>", ":w<CR>", {})
vim.keymap.set("i", "<C-s>", function()
    vim.api.nvim_command("write")
    vim.api.nvim_command("startinsert")
end, {})

-- indent right
vim.keymap.set("n", "<C-\\>", ">><right><right><right><right>", {})
vim.keymap.set("v", "<C-\\>", ">gv<right><right><right><right>", {})
vim.keymap.set("i", "<C-\\>", "<ESC>>><right><right><right><right>gi", {})

-- indent left
vim.keymap.set("n", "<C-]>", "<<<left><left><left><left>", {})
vim.keymap.set("v", "<C-]>", "<gv<left><left><left><left>", {})
vim.keymap.set("i", "<C-]>", "<ESC><<<left><left><left><left>gi", {})

-- shortcuts - neotree
vim.keymap.set("n", "<C-b>", ":Neotree filesystem reveal left<CR>", {})

-- shortcuts - telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

-- shortcuts - LSP
-- https://neovim.io/doc/user/lsp.html
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<C-;>", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<C-S-:>", vim.lsp.buf.references, {})
vim.keymap.set("n", "<C-.>", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<C-S-i>", vim.lsp.buf.format, {})

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

-- shortcuts - nvim-spectre
-- require("spectre").setup()
-- vim.keymap.set("n", "<leader>S", "<cmd>lua require(\"spectre\").toggle()<CR>", {
--     desc = "Toggle Spectre",
-- })
-- vim.keymap.set("n", "<leader>sw", "<cmd>lua require(\"spectre\").open_visual({select_word=true})<CR>", {
--     desc = "Search current word",
-- })
-- vim.keymap.set("v", "<leader>sw", "<esc><cmd>lua require(\"spectre\").open_visual()<CR>", {
--     desc = "Search current word",
-- })
-- vim.keymap.set("n", "<leader>sp", "<cmd>lua require(\"spectre\").open_file_search({select_word=true})<CR>", {
--     desc = "Search on current file",
-- })
