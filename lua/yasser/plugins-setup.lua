local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	-- colors
	use("bluz71/vim-nightfly-colors")
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("AlexvZyl/nordic.nvim")
	--- dashboard
	use({ "glepnir/dashboard-nvim", event = "VimEnter", dependencies = { "nvim-tree/nvim-web-devicons" } })
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")
	use("jacoborus/tender.vim")
	use("jaredgorski/spacecamp")
	use("christoomey/vim-tmux-navigator")
	use("szw/vim-maximizer")
	use("numToStr/Comment.nvim")
	use("nvim-tree/nvim-tree.lua")
	use("kyazdani42/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })
	use("nvim-telescope/telescope-ui-select.nvim")

	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")

	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets
	use("fatih/vim-go")
	--lsp servers

	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

	-- LSP
	use("neovim/nvim-lspconfig")
	use("hrsh7th/cmp-nvim-lsp")
	use({ "nvimdev/lspsaga.nvim", branch = "main" })
	use("kabouzeid/nvim-lspinstall")
	use("onsails/lspkind-nvim")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/cmp-nvim-lua")
	--- ref
	use({
		"wiliamks/nice-reference.nvim",
		requires = {
			"kyazdani42/nvim-web-devicons", --optional
			{
				"rmagatti/goto-preview",
				config = function()
					require("goto-preview").setup({})
				end,
			}, --optional
		},
	})
	-- formating and linting
	use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			require("toggleterm").setup()
		end,
	})
	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side
	use("nvim-telescope/telescope-project.nvim")
	use({
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
	use({
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"nvim-telescope/telescope.nvim", -- optional
			"sindrets/diffview.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
		},
		config = true,
	})
	use({ "stevearc/aerial.nvim" })
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	--- for rust
	use("simrat39/rust-tools.nvim")
	-- trouble
	use({ "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } })
	if packer_bootstrap then
		require("packer").sync()
	end
end)
