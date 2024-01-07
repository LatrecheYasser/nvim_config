local setup, trouble = pcall(require, "trouble")
if not setup then
	print("no trouble plugin is installed, please install it")
	return
end
trouble.setup()
