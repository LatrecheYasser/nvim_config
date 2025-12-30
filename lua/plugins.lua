---------------------------  setup lazy.vim ------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
--------------- installing/loading pkgs ----------------------------
local plugins_path = "plugins"
local theme_path = plugins_path..".themes"
require("lazy").setup({
    {
	import = theme_path..".kanagawa-colorscheme",
    },
    {
	import = plugins_path..".treesitter.setup",
    },
    {
	import = plugins_path..".lspconfig.setup",

    },
    {
	import = plugins_path..".blink_cmp.setup"
    },
    {
	import = plugins_path..".lazydev.setup",
    },
    {
	import = plugins_path..".telescope.setup",
    },
    {
	import = plugins_path..".nvim-tree.setup",
    },
    {
	import  = plugins_path..".smart-splits.setup"
    },
    {
	import = plugins_path..".lualina.setup",
    },
    {
	import = plugins_path..".diff.setup",
    }
})
