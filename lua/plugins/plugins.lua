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

      -- vim.keymap.set("n", "<leader><leader>", ))

      local builtin = require("telescope.builtin")

      -- local function safe_telescope_call(tele_func, tele_opts)
      --   return function()
      --     -- local ok, result = pcall(tele_func, tele_opts or {})
      --     local ok = false
      --     if not ok then
      --       vim.notify("!!!!!! Telescope call failed: " .. result, vim.log.levels.WARN)
      --
      --       -- Return an empty picker so Telescope still shows something
      --       require("telescope.pickers")
      --         .new({}, {
      --           prompt_title = "No results",
      --           finder = require("telescope.finders").new_table({ results = {} }),
      --           sorter = require("telescope.config").values.generic_sorter({}),
      --         })
      --         :find()
      --     end
      --   end
      -- end

      local function has_quickfixlist()
        local qflist = vim.fn.getqflist()
        return #qflist > 0
      end

      local function is_lsp_attached()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        return #clients > 0
      end

      local function has_lsp_implementations()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
          if client.server_capabilities.implementationProvider then
            return true
          end
        end
        return false
      end

      local function has_lsp_definitions()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
          if client.server_capabilities.definitionProvider then
            return true
          end
        end
        return false
      end

      local function has_lsp_type_definitions()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
          if client.server_capabilities.typeDefinitionProvider then
            return true
          end
        end
        return false
      end
      --
      --
      local has_lsp = is_lsp_attached()

      require("search").setup({
        mappings = { -- optional: configure the mappings for switching tabs (will be set in normal and insert mode(!))
          next = "<Tab>",
          prev = "<S-Tab>",
        },

        append_tabs = { -- append_tabs will add the provided tabs to the default ones
          { name = "buffers", tele_func = builtin.buffers },
          { name = "All Files", tele_func = builtin.find_files, tele_opts = { no_ignore = true, hidden = true } },
          { name = "Quickfix", tele_func = has_quickfixlist() and builtin.quickfix or nil },

          -- { name = "Quickfix", tele_func = builtin.quickfix },
          { name = "Quickfix Hist", tele_func = has_quickfixlist() and builtin.quickfix_history or nil },
        },

        collections = {
          git = {
            initial_tab = 1, -- Git Stashes
            tabs = {
              { name = "Stashes", tele_func = builtin.git_status },
              { name = "Branches", tele_func = builtin.git_branches },
              { name = "Commits", tele_func = builtin.git_commits },
              { name = "Stashes", tele_func = builtin.git_stash },
            },
          },
          lsp = {
            initial_tab = 1, -- is_lsp_attached() and 0 or 6, -- Set dynamically
            tabs = {
              {
                name = "Methods and functions",
                tele_func = builtin.lsp_document_symbols,
                tele_opts = { symbols = { "Function", "Method", "Class" } },
              },
              -- { name = "References", tele_func = builtin.lsp_references },
              {
                name = "Implementations",
                -- tele_func = lsp_implementations,
                tele_func = has_lsp_implementations() and builtin.lsp_implementations or nil,
              },
              {
                name = "Definitions",
                tele_func = has_lsp_definitions() and builtin.lsp_definitions or nil,
                -- tele_func = builtin.lsp_definitions,
              },
              {
                name = "Type Definitions",
                -- tele_func = builtin.lsp_document_symbols,
                tele_func = has_lsp_type_definitions() and builtin.lsp_type_definitions or nil,
              },

              { name = "All Files", tele_func = builtin.find_files, tele_opts = { no_ignore = true, hidden = true } },
            },
          },
        },
        -- end of setup
      })

      vim.keymap.set("n", "<C-o>", search.open)
      vim.keymap.set("n", "<C-i>", function()
        search.open({ collection = "lsp" })
      end, { desc = "List functions, methods, and classes via LSP" })
      vim.keymap.set("n", "<C-p>", function()
        search.open({ collection = "git" })
      end, { desc = "List git stuff" })
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
      vim.cmd([[nnoremap <C-e> :Neotree reveal]])
    end,
  },
}

table.insert(plugins, require("plugins.dap"))
table.insert(plugins, require("plugins.extras"))
table.insert(plugins, require("plugins.noice"))
table.insert(plugins, require("plugins.neotest"))

return plugins
