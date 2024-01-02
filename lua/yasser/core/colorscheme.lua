local status, _ = pcall(vim.cmd, "colorscheme nordic")
if not status then
	print("colorscheme nordic not found")
	return
end
