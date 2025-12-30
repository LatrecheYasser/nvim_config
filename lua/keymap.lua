
------------------- lsp
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  end,
})


--------------- telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Telescope help tags' })


---------------nvim-tree
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { desc = "Toggle nvim-tree" })
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { desc = "Focus nvim-tree" })

--------------- smart-splits
vim.keymap.set('n', '<leader>sh', require('smart-splits').resize_left)
vim.keymap.set('n', '<leader>sj', require('smart-splits').resize_down)
vim.keymap.set('n', '<leader>sk', require('smart-splits').resize_up)
vim.keymap.set('n', '<leader>sl', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<leader>h', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<leader>j', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<leader>k', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<leader>l', require('smart-splits').move_cursor_right)
vim.keymap.set('n', '<leader>p', require('smart-splits').move_cursor_previous)
-- swapping buffers between windows
vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
----- create new splits
vim.keymap.set('n', '<leader>nh', vim.cmd.split)
vim.keymap.set('n', '<leader>nv', vim.cmd.vsplit)
