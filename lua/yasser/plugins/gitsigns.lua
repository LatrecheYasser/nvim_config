-- import gitsigns plugin safely
local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
	return
end

-- configure/enable gitsigns
gitsigns.setup({
	current_line_blame = true,
	numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = true, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = true, -- Toggle with `:Gitsigns toggle_word_diff`
	current_line_blame_opts = {
		delay = 500,
	},
})
