local status, lazygit = pcall(require, "lazygit")
if not status then
	print("no lazygit")
	return
end
lazygit.setup()
