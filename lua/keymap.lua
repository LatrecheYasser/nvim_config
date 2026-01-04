
--------------- bufferline
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })

--------------- navigation
vim.keymap.set("n", "<C-->", "<C-o>", { desc = "Jump back" })
vim.keymap.set("n", "<C-S-->", "<C-i>", { desc = "Jump forward" })

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
--------------- lsp saga
local opts = { noremap = true, silent = true }

-- =========================
-- HOVER / INFO
-- =========================
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts)

-- =========================
-- GOTO / PEEK
-- =========================
vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
vim.keymap.set("n", "sd", "<cmd>Lspsaga peek_definition<CR>", opts)
vim.keymap.set("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", opts)
vim.keymap.set("n", "gi", "<cmd>Lspsaga goto_implementation<CR>", opts)

-- =========================
-- FINDER
-- =========================
vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", opts)

-- =========================
-- CODE ACTIONS
-- =========================
vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)

-- =========================
-- RENAME
-- =========================
vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)

-- =========================
-- DIAGNOSTICS
-- =========================
vim.keymap.set("n", "<leader>e", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
vim.keymap.set("n", "<leader>E", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)

vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)

-- Errors only
vim.keymap.set("n", "[D", function()
  require("lspsaga.diagnostic"):goto_prev({
    severity = vim.diagnostic.severity.ERROR,
  })
end, opts)

vim.keymap.set("n", "]D", function()
  require("lspsaga.diagnostic"):goto_next({
    severity = vim.diagnostic.severity.ERROR,
  })
end, opts)

-- =========================
-- CALL HIERARCHY
-- =========================
vim.keymap.set("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", opts)
vim.keymap.set("n", "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>", opts)

-- =========================
-- TERMINAL (OPTIONAL)
-- =========================
vim.keymap.set("n", "<leader>tt", "<cmd>Lspsaga term_toggle<CR>", opts)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

