return {
    "f-person/git-blame.nvim",
    config = function()
	require("gitblame").setup({
	    enabled = true,
	    display_virtual_text = false, -- disable inline text, we show it in lualine
	    date_format = "%r", -- relative time
	    message_template = "<author> • <date> • <summary>",
	})
    end,
}
