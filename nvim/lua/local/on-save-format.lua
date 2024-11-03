-- List of filetypes where you want to disable auto-formatting
local excluded_filetypes = { "json", "markdown", "txt" }

-- Table of specific settings for filetypes
local filetype_settings = {
    make = {
        expandtab = false, -- Use hard tabs for Makefiles
        tabstop = 4, -- A tab character is 8 spaces wide
        shiftwidth = 4, -- Indentation is 8 spaces wide
    },
    nix = {
        shiftwidth = 2, -- Indentation is 2 spaces wide
    },
    -- You can add more filetypes here if needed, e.g.
    -- lua = { expandtab = true, tabstop = 4, shiftwidth = 4 }
}

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

        -- Apply filetype-specific settings if they exist
        if filetype_settings[filetype] then
            local settings = filetype_settings[filetype]
            vim.bo.expandtab = settings.expandtab
            vim.bo.tabstop = settings.tabstop
            vim.bo.shiftwidth = settings.shiftwidth
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
