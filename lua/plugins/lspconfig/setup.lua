local function venv_cmd(bin, args)
    return function(config)
	for _, dir in ipairs({ ".venv", "venv" }) do
	    local path = vim.fs.joinpath(config.root_dir or "", dir, "bin", bin)
	    if vim.fn.executable(path) == 1 then
		return vim.list_extend({ path }, args)
	    end
	end
	return vim.list_extend({ bin }, args)
    end
end

return {
    "neovim/nvim-lspconfig",
    config = function()
	vim.lsp.enable("clangd")
	vim.lsp.config("gopls", {
	    cmd = { "dd-gopls" },
	})
	vim.lsp.enable("gopls")
	vim.lsp.enable("lua_ls")
	vim.lsp.enable("terraformls")
	vim.lsp.config("basedpyright", {
	    cmd = venv_cmd("basedpyright-langserver", { "--stdio" }),
	})
	vim.lsp.enable("basedpyright")
	vim.lsp.config("ruff", {
	    cmd = venv_cmd("ruff", { "server" }),
	})
	vim.lsp.enable("ruff")
    end,
}
