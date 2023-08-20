-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	print("no telescope")
	return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	print("no telescope ations")
	return
end

-- import telescope-ui-select safely
local themes_setup, themes = pcall(require, "telescope.themes")
if not themes_setup then
	print("no telescope themes")
	return
end

-- configure telescope
telescope.setup({
	-- configure custom mappings
	defaults = {
		mappings = {
			i = {
				["<C-p>"] = actions.move_selection_previous, -- move to prev result
				["<C-n>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
	},
	extensions = {
		["ui-select"] = {
			themes.get_dropdown({}),
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("project")
