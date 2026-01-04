return {
    'nvimdev/lspsaga.nvim',
    config = function()
	require('lspsaga').setup({
	    finder = {
		keys = {
		    edit = '<CR>',
		},
	    },
	})
    end,
    dependencies = {
	'nvim-treesitter/nvim-treesitter', -- optional
	'nvim-tree/nvim-web-devicons',     -- optional
    }
}
