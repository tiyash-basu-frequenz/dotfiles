-- set tab to 4 spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- spellcheck
vim.cmd("set spell")
vim.cmd("set spelllang=en_us")

-- enable line numbers
vim.cmd("set number")

-- copy to clipboard
vim.cmd("set clipboard+=unnamedplus")

-- set rulers
vim.cmd("set colorcolumn=80,100,120")

-- enable file type detection
vim.cmd("filetype off")
vim.cmd("filetype plugin indent on")

-- enable copilot for git commit messages
vim.g.copilot_filetypes = { gitcommit = true }
