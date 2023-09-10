local setup, comment = pcall(require, "Comment")
if not setup then
	print("no comment")
	return
end

comment.setup({
	ignore = "^$",
	toggler = {
		line = "<leader>/",
		block = "<leader>cb",
	},
	opleader = {
		line = "<leader>c",
		block = "<leader>b",
	},
})
