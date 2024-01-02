require("yasser.plugins-setup")
require("yasser.core.options")
require("yasser.core.keymaps")
require("yasser.core.colorscheme")
require("yasser.plugins.comment")
require("yasser.plugins.nvim-tree")
require("yasser.plugins.lualine")
require("yasser.plugins.telescope")
require("yasser.plugins.nvim-cmp")
require("yasser.plugins.lsp.mason")
require("yasser.plugins.lsp.lspconfig")
require("yasser.plugins.lsp.lspsaga")
require("yasser.plugins.lsp.null-ls")
require("yasser.plugins.autopairs")
require("yasser.plugins.treesitter")
require("yasser.plugins.gitsigns")
require("yasser.plugins.toggleterm")
require("yasser.plugins.rust-tool")
require("yasser.plugins.neogit")
require("yasser.plugins.nice-reference")
require("yasser.plugins.aerial")

-- LSP Diagnostics Options Setup
local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = "",
	})
end

sign({ name = "DiagnosticSignError", text = "E" })
sign({ name = "DiagnosticSignWarn", text = "W" })
sign({ name = "DiagnosticSignHint", text = "!" })
sign({ name = "DiagnosticSignInfo", text = "" })

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = false,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

vim.g.go_textobj_enabled = 0
vim.g.go_doc_keywordprg_enabled = 0
vim.g.go_def_mapping_enabled = 0
