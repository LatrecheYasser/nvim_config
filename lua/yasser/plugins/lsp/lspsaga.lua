-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
	print("no lspsaga")
	return
end

saga.setup({
	-- keybinds for navigation in lspsaga window
	scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
	-- use enter to open file with definition preview
	finder_auto_open = true,
	definition = {
		edit = "<CR>",
	},
	ui = {
		colors = {
			normal_bg = "#022746",
		},
	},
})
