local status, neogit = pcall(require, "neogit")
if not status then
	print("no neogit")
	return
end

neogit.setup()
