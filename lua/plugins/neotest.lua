local DOTNET_NO_BUILD = "--no-build"

local function dotnet_build(on_success)
  local cwd = vim.fn.getcwd()
  vim.notify("dotnet build...", vim.log.levels.INFO)
  vim.fn.jobstart("dotnet build", {
    cwd = cwd,
    stdout_buffered = true,
    stderr_buffered = true,
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify("Build succeeded", vim.log.levels.INFO)
          on_success()
        else
          vim.notify("dotnet build failed — tests skipped", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end

local function run_test(run_fn)
  if vim.bo.filetype == "cs" then
    dotnet_build(run_fn)
  else
    run_fn()
  end
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-jest",
    "Issafalcon/neotest-dotnet",
  },
  keys = {
    {
      "<leader>tt",
      function()
        run_test(function() require("neotest").run.run(vim.fn.expand("%")) end)
      end,
      desc = "Run File",
    },
    {
      "<leader>tT",
      function()
        run_test(function() require("neotest").run.run(vim.loop.cwd()) end)
      end,
      desc = "Run All Test Files",
    },
    {
      "<leader>tr",
      function()
        run_test(function() require("neotest").run.run() end)
      end,
      desc = "Run Nearest",
    },
    {
      "<leader>tB",
      function() dotnet_build(function() end) end,
      desc = "Build .NET Project",
    },
    {
      "<leader>ts",
      function() require("neotest").summary.toggle() end,
      desc = "Toggle Summary",
    },
    {
      "<leader>to",
      function() require("neotest").output.open({ enter = true, auto_close = true }) end,
      desc = "Show Output",
    },
    {
      "<leader>tO",
      function() require("neotest").output_panel.toggle() end,
      desc = "Toggle Output Panel",
    },
    {
      "<leader>tS",
      function() require("neotest").run.stop() end,
      desc = "Stop",
    },
  },
  config = function()
    local neotest_ns = vim.api.nvim_create_namespace("neotest")

    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          return diagnostic.message
            :gsub("\n", " ")
            :gsub("\t", " ")
            :gsub("%s+", " ")
            :gsub("^%s+", "")
        end,
      },
    }, neotest_ns)

    ---@diagnostic disable-next-line: missing-fields
    require("neotest").setup({
      adapters = {
        require("neotest-go"),
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function() return vim.fn.getcwd() end,
          isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
        }),
        require("neotest-dotnet")({
          dap = {
            args = { justMyCode = false },
            adapter_name = "coreclr",
          },
          discovery_root = "solution",
          dotnet_additional_args = { DOTNET_NO_BUILD },
        }),
      },
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "❌",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        passed = "✅",
        running = " ",
        running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
        skipped = "⏭️",
        unknown = "",
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = true,
      },
      floating = {
        enabled = true,
        border = "rounded",
        max_height = 0.9,
        max_width = 0.9,
        options = {},
      },
      quickfix = {
        enabled = true,
        open = function()
          vim.cmd("Trouble quickfix")
        end,
      },
    })
  end,
}
