return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local ts = require("typescript")

      lspKeySetup = function(client, bufnr)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
          desc = "GOTO Defintion",
          noremap = true,
          silent = true,
          buffer = bufnr,
        })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {
          desc = "Hoover Definition",
          noremap = true,
          silent = true,
          buffer = bufnr,
        })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
          desc = "Rename Symbol",
          noremap = true,
          silent = true,
          buffer = bufnr,
        })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
          desc = "Code Action",
          noremap = true,
          silent = true,
          buffer = bufnr,
        })
      end

      ts.setup({
        server = {
          on_attach = function(client, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
          end,
        },
      })

      -- GO
      require("lspconfig").gopls.setup({
        on_attach = function(client, bufnr)
          lspKeySetup(client, bufnr)
        end,
      })

      -- python
      require("lspconfig").pylsp.setup({
        on_attach = function(client, bufnr)
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts) -- TODO , change to leader c R
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        end,
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = true },
              pycodestyle = { enabled = true },
              black = { enabled = true },
              isort = { enabled = true },
            },
          },
        },
      })

      -- C#
      require("lspconfig").omnisharp.setup({
        on_attach = function(client, bufnr)
          lspKeySetup(client, bufnr)
        end,
        cmd = { "omnisharp" },
        -- cmd = { "omnisharp", "--languageserver" },
        settings = {
          omnisharp = {
            enableRoslynAnalyzers = true,
            organizeImportsOnFormat = true,
            enableEditorConfigSupport = true,
          },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap = require("dap")
      local dapgo = require("dap-go")
      dapgo.setup()

      -- Keybindings for debugging
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue Debugging" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
      vim.keymap.set(
        "n",
        "<leader>db",
        dap.toggle_breakpoint,
        { desc = "Toggle Breakpoint" }
      )
    end,
  },

  -- LSP
  -- {
  --   "neovim/nvim-lspconfig",
  --   cmd = { "LspInfo", "LspInstall", "LspStart" },
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = {
  --     "hrsh7th/nvim-cmp",
  --     { "hrsh7th/cmp-nvim-lsp" },
  --     { "williamboman/mason.nvim" },
  --     { "williamboman/mason-lspconfig.nvim" },
  --   },
  --   init = function()
  --     -- Reserve a space in the gutter
  --     -- This will avoid an annoying layout shift in the screen
  --     vim.opt.signcolumn = "yes"
  --   end,
  --
  --   config = function()
  --     local lsp_defaults = require("lspconfig").util.default_config
  --
  --     -- Add cmp_nvim_lsp capabilities settings to lspconfig
  --     -- This should be executed before you configure any language server
  --     lsp_defaults.capabilities = vim.tbl_deep_extend(
  --       "force",
  --       lsp_defaults.capabilities,
  --       require("cmp_nvim_lsp").default_capabilities()
  --     )
  --
  --     -- LspAttach is where you enable features that only work
  --     -- if there is a language server active in the file
  --     vim.api.nvim_create_autocmd("LspAttach", {
  --       desc = "LSP actions",
  --       callback = function(event)
  --         local opts = { buffer = event.buf }
  --
  --         vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
  --         vim.keymap.set(
  --           "n",
  --           "gd",
  --           "<cmd>lua vim.lsp.buf.definition()<cr>",
  --           opts
  --         )
  --         vim.keymap.set(
  --           "n",
  --           "gD",
  --           "<cmd>lua vim.lsp.buf.declaration()<cr>",
  --           opts
  --         )
  --         vim.keymap.set(
  --           "n",
  --           "gi",
  --           "<cmd>lua vim.lsp.buf.implementation()<cr>",
  --           opts
  --         )
  --         vim.keymap.set(
  --           "n",
  --           "go",
  --           "<cmd>lua vim.lsp.buf.type_definition()<cr>",
  --           opts
  --         )
  --         vim.keymap.set(
  --           "n",
  --           "gr",
  --           "<cmd>lua vim.lsp.buf.references()<cr>",
  --           opts
  --         )
  --         vim.keymap.set(
  --           "n",
  --           "gs",
  --           "<cmd>lua vim.lsp.buf.signature_help()<cr>",
  --           opts
  --         )
  --         vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  --         vim.keymap.set(
  --           { "n", "x" },
  --           "<F3>",
  --           "<cmd>lua vim.lsp.buf.format({async = true})<cr>",
  --           opts
  --         )
  --         vim.keymap.set(
  --           "n",
  --           "<F4>",
  --           "<cmd>lua vim.lsp.buf.code_action()<cr>",
  --           opts
  --         )
  --       end,
  --     })
  --     require("mason-lspconfig").setup({
  --       ensure_installed = {},
  --       handlers = {
  --         -- this first function is the "default handler"
  --         -- it applies to every language server without a "custom handler"
  --         function(server_name)
  --           require("lspconfig")[server_name].setup({})
  --         end,
  --       },
  --     })
  --   end,
  -- },
}
