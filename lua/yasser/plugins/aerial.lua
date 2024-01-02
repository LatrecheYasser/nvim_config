local status, aerial = pcall(require, "aerial")
if not status then
	print("no aerial")
	return
end
aerial.setup()
