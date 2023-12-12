vim.g.mapleader = " "
local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>")

keymap.set("n", "<leader>nh", "nohl<CR>")
keymap.set("n", "x", '"_x')

------ Tmux
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sb", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sx", ":close<CR>")

keymap.set("n", "<leader>sh", ":TmuxNavigateLeft<CR>")
keymap.set("n", "<leader>sl", ":TmuxNavigateRight<CR>")
keymap.set("n", "<leader>sk", ":TmuxNavigateUp<CR>")
keymap.set("n", "<leader>sj", ":TmuxNavigateDown<CR>")

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

--------------plugin keymaps
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")
-- nvim tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
------------- telescope

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

------ terminal
keymap.set("n", "<leader>j", "<cmd>ToggleTerm<cr>") --- toggle terminal
keymap.set("n", "<leader>fp", "<cmd>Telescope project<cr>")
-- trying to move lines

keymap.set("n", "K", "<cmd>move -2<cr>")
keymap.set("n", "J", "<cmd>move +1<cr>")
---- ref
--
keymap.set("n", "gr", "<cmd>NiceReference<cr>")
