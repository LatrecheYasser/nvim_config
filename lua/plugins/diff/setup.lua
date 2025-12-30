return{
    {
	'sindrets/diffview.nvim',
    },
    {
	"julienvincent/hunk.nvim",
	cmd = { "DiffEditor" },
	config = function()
	    require("hunk").setup()
	end,
    }

}
