local plugins = {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("tiny-inline-diagnostic").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required dependency
      "nvim-telescope/telescope-fzf-native.nvim", -- Optional, adds better sorting
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "%.git/", "^node_modules/" }, -- Ignore `.git/` but not other hidden files
          pickers = {
            find_files = {
              hidden = true, -- Include hidden files by default
            },
          },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
      })
      -- Load fzf extension if installed
      pcall(require("telescope").load_extension, "fzf")
      vim.keymap.set("n", "<M-h>", function()
        require("telescope.builtin").find_files({ hidden = true })
      end, { desc = "Find files (including hidden)" })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            visible = true, -- Show hidden files and directories
            hide_dotfiles = false, -- Ensure dotfiles are not hidden
            hide_gitignored = false, -- Ensure gitignored files are not hidden
          },
        },
      })
    end,
  },
}

table.insert(plugins, require("plugins.dap"))
table.insert(plugins, require("plugins.extras"))
table.insert(plugins, require("plugins.noice"))
table.insert(plugins, require("plugins.neotest"))

return plugins
