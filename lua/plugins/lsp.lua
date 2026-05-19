local lspKeySetup = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

return {
  -- Mason for language servers / formatters
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- LSP config
  {
    "Cliffback/netcoredbg-macOS-arm64.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- TypeScript
      require("typescript").setup({
        server = {
          on_attach = lspKeySetup,
        },
      })

      -- Go
      require("lspconfig").gopls.setup({
        on_attach = lspKeySetup,
      })

      -- Python
      require("lspconfig").pylsp.setup({
        on_attach = lspKeySetup,
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

    end,
  },

  -- DAP for debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "leoluz/nvim-dap-go",
      "Weissle/persistent-breakpoints.nvim",
    },
    config = function()
      local dap = require("dap")

      -- C# adapter
      dap.adapters.coreclr = {
        type = "executable",
        command = os.getenv("HOME") .. "/vsdbg/vsdbg",
        args = { "--interpreter=vscode" },
      }

      -- Go DAP
      require("dap-go").setup()

      -- Virtual text + persistent breakpoints
      require("nvim-dap-virtual-text").setup({})
      vim.g.dap_virtual_text = true
      require("persistent-breakpoints").setup({
        load_breakpoints_event = { "BufReadPost" },
      })

      -- DAP UI
      local dapui = require("dapui")
      dapui.setup()
      local wk = require("which-key")
      local vscode = require("dap.ext.vscode")
      local dapwidgets = require("dap.ui.widgets")
      local perstbreakpoints = require("persistent-breakpoints.api")

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "🟥", texthl = "", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = "▶️", texthl = "", linehl = "", numhl = "" }
      )

      wk.add({
        { "<F5>", dap.continue, desc = "Start/Continue Debugging" },
        { "<F10>", dap.step_over, desc = "Step Over" },
        { "<F11>", dap.step_into, desc = "Step Into" },
        { "<F12>", dap.step_out, desc = "Step Out" },
        {
          "<leader>db",
          perstbreakpoints.toggle_breakpoint,
          desc = "Toggle Breakpoint",
        },
        { "<leader>dB", dap.clear_breakpoints, desc = "Clear All Breakpoints" },
        { "<leader>du", dapui.toggle, desc = "Toggle Dap UI" },
        {
          "<leader>dv",
          function()
            vscode.load_launchjs(nil, {})
            dap.continue()
          end,
          desc = "Load launch.json and continue",
        },
      })
    end,
  },

  -- DAP UI layout
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      layouts = {
        {
          elements = {
            { id = "console", size = 0.60 },
            { id = "scopes", size = 0.30 },
            { id = "breakpoints", size = 0.10 },
          },
          position = "left",
          size = 75,
        },
      },
    },
  },

  "jay-babu/mason-nvim-dap.nvim",
  "mfussenegger/nvim-dap-python",
  { "nvim-neotest/nvim-nio", lazy = true },
  { "Weissle/persistent-breakpoints.nvim" },
}
