return {
  -- mason nivm dap
  "williamboman/mason.nvim",
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

      -- Setup the go debug adapter
      require("dap-go").setup()

      -- Setup DAP virtual text
      require("nvim-dap-virtual-text").setup({})
      vim.g.dap_virtual_text = true

      -- Allows breakpoints to last between sessions
      require("persistent-breakpoints").setup({
        load_breakpoints_event = { "BufReadPost" },
      })

      -- Setup DAP UI
      local dapui = require("dapui")
      local wk = require("which-key")
      local vscode = require("dap.ext.vscode")
      local dapwidgets = require("dap.ui.widgets")
      local perstbreakpoints = require("persistent-breakpoints.api")

      -- Adding symbols for breakpoints and such
      vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

      wk.add({
        { "<F5>", dap.continue, desc = "Start/Continue Debugging" },
        { "<F10>", dap.step_over, desc = "Step Over" },
        { "<F11>", dap.step_into, desc = "Step Into" },
        { "<F12>", dap.step_out, desc = "Step Out" },
        { "<leader>dd", dap.step_over, desc = "Step Over" },
        { "<leader>di", dap.step_into, desc = "Step Into" },
        { "<leader>do", dap.step_out, desc = "Step Out" },
        { "<leader>dc", dap.continue, desc = "Start/Continue Debugging" },
        { "<leader>db", perstbreakpoints.toggle_breakpoint, desc = "Toggle Breakpoint" },
        { "<leader>dB", dap.clear_breakpoints, desc = "Clear All Breakpoints" },
        { "<leader>du", dapui.toggle, desc = "Toggle Dap UI" },
        { "<leader>dl", dap.run_last, desc = "Run Last Debug Session" },
        { "<leader>dr", dap.repl.open, desc = "Open REPL" },
        { "<leader>dq", dap.terminate, desc = "Terminate Debug Session" },
        {
          "<leader>dv",
          function()
            vscode.load_launchjs(nil, {})
            print("Loaded VS Code launch.json configurations")
          end,
          desc = "Load Debug Config from launch.json",
        },
        {
          "<leader>dv",
          function()
            vscode.load_launchjs(nil, {})
            print("Loaded VS Code launch.json configurations")
            dap.continue()
          end,
          desc = "Load Debug Config from launch.json",
        },
        {
          "<leader>dB",
          function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Set Conditional Breakpoint",
        },
        {
          "<leader>dh",
          function()
            dapwidgets.hover(nil, { use_visual_selection = true })
          end,
          desc = "hover widgets",
        },
        { "<leader>dh", dapwidgets.preview, desc = "preview widgets" },
        {
          "<leader>dw",
          function()
            dapwidgets.centered_float(dapwidgets.scopes)
          end,
          desc = "float scopes",
        },
        {
          "<leader>de",
          function()
            dapwidgets.centered_float(dapwidgets.expression)
          end,
          desc = "float expression",
        },
        {
          "<leader>df",
          function()
            dapwidgets.centered_float(dapwidgets.frames)
          end,
          desc = "float frames",
        },
      })
    end,
  },
  "jay-babu/mason-nvim-dap.nvim",
  "mfussenegger/nvim-dap-python",
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
        -- {
        --   elements = {
        --     { id = "repl", size = 0.5 },
        --     -- { id = "stacks", size = 0.33 },
        --     { id = "watches", size = 0.5 },
        --   },
        --   position = "bottom",
        --   size = 10,
        -- },
      },
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)

      -- Automatically open/close UI when debugging starts/ends
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- dapui.close()
      end

      local wk = require("which-key")
      wk.add({ "<leader>dt", dapui.toggle, desc = "toggle ui" })

      vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
    end,
  },
  { "nvim-neotest/nvim-nio", lazy = true },
  { "Weissle/persistent-breakpoints.nvim" },
}
