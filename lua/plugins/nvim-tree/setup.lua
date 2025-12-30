return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- NEW MAPPING SYSTEM: Define on_attach function
    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Default mappings (Optional: delete this line if you want ONLY your custom keys)
      api.config.mappings.default_on_attach(bufnr)

      -- YOUR CUSTOM MAPPINGS
      -- Format: vim.keymap.set('n', 'YOUR_KEY', api.action.name, opts('Description'))
      
      -- Unbind defaults you don't want (set to nil or simply override)
      vim.keymap.set('n', 'd', api.tree.change_root_to_node, opts('CD'))
      vim.keymap.set('n', 'x', api.fs.remove,               opts('Delete'))
      vim.keymap.set('n', 't', api.fs.cut,                  opts('Cut'))
      
      vim.keymap.set('n', '<Space>p', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
      vim.keymap.set('n', '<Space>.', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
      vim.keymap.set('n', '<Space>k', api.node.navigate.git.prev,         opts('Prev Git'))
      vim.keymap.set('n', '<Space>j', api.node.navigate.git.next,         opts('Next Git'))
      
      vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
      vim.keymap.set('n', "'", api.node.navigate.parent_close, opts('Close Node'))
      vim.keymap.set('n', '"', api.tree.collapse_all,          opts('Collapse All'))
      vim.keymap.set('n', '?', api.tree.toggle_help,           opts('Help'))
    end

    require("nvim-tree").setup({
      on_attach = my_on_attach, -- Attach the new mapping function here
      create_in_closed_folder = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      -- open_on_setup removed (Not supported anymore)
      
      view = {
        adaptive_size = false,
        -- mappings.list removed (Now handled in on_attach)
      },
      renderer = {
	  full_name = true,
	  group_empty = true,
	  special_files = {},
	  symlink_destination = false,
	  indent_markers = {
	      enable = true,
	  },
	  icons = {
	      git_placement = "signcolumn",
	      show = {
		  file = true,
		  folder = true,        -- WAS FALSE: Set to true to see folder icons
		  folder_arrow = true,  -- Set to true to see the small arrow next to folders
		  git = true,
	      },
	      glyphs = {
		  default = "󰈚",
		  symlink = "",
		  folder = {
		      arrow_closed = "", -- Icon when folder is closed
		      arrow_open = "",   -- Icon when folder is open
		      default = "",      -- Folder icon
		      open = "",         -- Open folder icon
		      empty = "",        -- Empty folder icon
		      empty_open = "",   -- Empty open folder icon
		      symlink = "",
		      symlink_open = "",
		  },
		  git = {
		      unstaged = "✗",
		      staged = "✓",
		      unmerged = "",
		      renamed = "➜",
		      untracked = "★",
		      deleted = "",
		      ignored = "◌",
		  },
	      },
	  },
      },
      update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = { "help" },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      filters = {
        custom = { "^.git$" },
      },
      actions = {
        change_dir = {
          enable = false,
          restrict_above_cwd = true,
        },
        open_file = {
          resize_window = true,
          window_picker = {
            chars = "aoeui",
          },
        },
        remove_file = {
          close_window = false,
        },
      },
    })
  end
}
