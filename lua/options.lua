------------------------------ Options ------------------------------------
-- enable line numbers and relative numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
--- split below 
vim.opt.splitbelow = true
vim.opt.splitright = true
-- sync a clipboard 
vim.opt.clipboard = "unnamedplus"
-- center the cursor 
vim.opt.scrolloff = 999
-- indent 
vim.opt.shiftwidth = 4
-- search and replace using a split window (use the cmd %s/old/new to do it)
vim.opt.inccommand = "split"
-- ignore casing 
vim.opt.ignorecase = true
-- enable colors 
vim.opt.termguicolors = true

--- set the leaderkey
vim.g.mapleader = " "
---------------------------- Configuration -------------------------------
-- show diagnostics 
vim.diagnostic.config({
    virtual_lines = true,
    signs = true,         -- Show icons in the gutter
    underline = true,     -- Underline the error
    update_in_insert = false, -- Only show errors after you leave Insert mode
})

---------- configuration to autosave

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        local mode = vim.api.nvim_get_mode().mode
        local filetype = vim.bo.filetype
        if vim.bo.modified == true and mode == 'n' and filetype ~= "oil" then
            vim.cmd('lua vim.lsp.buf.format()')
        else
        end
    end
})
