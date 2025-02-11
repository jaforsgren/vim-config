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
          position = "float",
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
      vim.cmd([[nnoremap <C-b> :Telescope buffers]])
      vim.keymap.set("n", "<M-h>", function()
        require("telescope.builtin").find_files({ hidden = true })
      end, { desc = "Find files (including hidden)" })
    end,
  },
  {
    "FabianWirth/search.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },

    config = function()
      local search = require("search")
      vim.keymap.set("n", "<C-o>", search.open)
      vim.keymap.set("n", "<leader><leader>", search.open)

      local builtin = require("telescope.builtin")
      require("search").setup({
        mappings = { -- optional: configure the mappings for switching tabs (will be set in normal and insert mode(!))
          next = "<Tab>",
          prev = "<S-Tab>",
        },
        --   tabs = {
        --   { name = "Branches", tele_func = builtin.},
        --   { name = "Commits", tele_func = builtin.gitt_commits },
        --   { name = "Stashes", tele_func = builtin.git_stash },
        -- }
        append_tabs = { -- append_tabs will add the provided tabs to the default ones
          { name = "buffers", tele_func = builtin.buffers },
          {
            "Commits", -- or name = "Commits"
            builtin.git_commits, -- or tele_func = require('telescope.builtin').git_commits
          },
          { name = "Branches", tele_func = builtin.git_branches },
          { name = "Stashes", tele_func = builtin.git_stash },

          { name = "All Files", tele_func = builtin.find_files, tele_opts = { no_ignore = true, hidden = true } },
          -- {
          --   name = "functions",
          --   tele_func = builtin.lsp_document_symbols,
          --   tele_opts = { symbols = { "Function", "Method", "Class" } },
          -- },
        },
      })
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
      -- vim.keymap.set("n", "<c-e>", ":Neotree reveal", {})
      vim.cmd([[nnoremap <C-e> :Neotree reveal]])
    end,
  },
}

table.insert(plugins, require("plugins.dap"))
table.insert(plugins, require("plugins.extras"))
table.insert(plugins, require("plugins.noice"))
table.insert(plugins, require("plugins.neotest"))

return plugins
