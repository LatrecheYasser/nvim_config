local status, ref = pcall(require, "nice-reference")
if not status then
	print("no refrence")
	return
end

ref.setup({
	anchor = "NW", -- Popup position anchor
	relative = "cursor", -- Popup relative position
	row = 1, -- Popup x position
	col = 0, -- Popup y position
	border = "rounded", -- Popup borderstyle
	winblend = 0, -- Popup transaparency 0-100, where 100 is transparent
	max_width = 120, -- Max width of the popup
	max_height = 10, -- Max height of the popup
	auto_choose = false, -- Go to reference if there is only one
})
