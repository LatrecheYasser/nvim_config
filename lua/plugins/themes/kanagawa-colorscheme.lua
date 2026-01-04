return {
	"catppuccin/nvim",
	name = "catppuccin",
	config = function()
		local bg = vim.opt.background:get()
		if bg == "light" then
			vim.cmd([[colorscheme catppuccin-latte]])
		else
			vim.cmd([[colorscheme catppuccin-mocha]])
		end
	end,
}
