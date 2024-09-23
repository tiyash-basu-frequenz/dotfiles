-- List of filetypes where you want to disable auto-formatting
local excluded_filetypes = { "json", "markdown", "txt" }

vim.api.nvim_create_augroup("AutoFormatting", {})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*" },
    group = "AutoFormatting",
    callback = function()
        -- Get the current buffer's filetype
        local filetype = vim.bo.filetype

        -- Check if the current file's filetype is in the excluded list
        if vim.tbl_contains(excluded_filetypes, filetype) then
            return -- Skip formatting for this file type
        end

        -- Proceed with formatting for other file types
        vim.lsp.buf.format({
            async = true,
            filter = function(client)
                return client.supports_method("textDocument/formatting")
            end,
        })
    end,
})
