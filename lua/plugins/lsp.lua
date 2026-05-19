local lspKeySetup = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>cA", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local errors = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })

    if #errors == 0 then
      vim.notify("No errors in buffer", vim.log.levels.INFO)
      return
    end

    -- Reverse order so bottom edits don't shift positions for earlier lines
    table.sort(errors, function(a, b)
      if a.lnum ~= b.lnum then return a.lnum > b.lnum end
      return a.col > b.col
    end)

    local fixed = 0
    -- Guard against infinite loops if an error has no fixable action
    local max_iterations = #errors * 2

    local function process_next(iteration)
      if iteration > max_iterations then
        vim.notify(("Auto-fixed %d error(s)"):format(fixed), vim.log.levels.INFO)
        return
      end

      -- Re-fetch diagnostics each iteration so positions are always fresh
      local remaining = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
      if #remaining == 0 then
        vim.notify(("Auto-fixed %d error(s)"):format(fixed), vim.log.levels.INFO)
        return
      end

      -- Take the bottom-most error so edits don't shift positions above
      table.sort(remaining, function(a, b)
        if a.lnum ~= b.lnum then return a.lnum > b.lnum end
        return a.col > b.col
      end)

      local diag = remaining[1]
      local lsp_diag = diag.user_data and diag.user_data.lsp or {}
      local params = {
        textDocument = { uri = vim.uri_from_bufnr(bufnr) },
        range = {
          start = { line = diag.lnum, character = diag.col },
          ["end"] = { line = diag.end_lnum or diag.lnum, character = diag.end_col or diag.col },
        },
        context = { diagnostics = { lsp_diag }, triggerKind = 1 },
      }

      vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(err, result)
        if err or not result or #result == 0 then
          vim.notify(("Auto-fixed %d / %d error(s) (remaining have no auto-fix)"):format(fixed, fixed + #remaining), vim.log.levels.INFO)
          return
        end

        local action
        for _, a in ipairs(result) do
          if a.kind == "quickfix" then
            action = a
            break
          end
        end

        if not action then
          vim.notify(("Auto-fixed %d / %d error(s) (remaining have no auto-fix)"):format(fixed, fixed + #remaining), vim.log.levels.INFO)
          return
        end
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
          fixed = fixed + 1
          process_next(iteration + 1)
        else
          vim.lsp.buf_request(bufnr, "codeAction/resolve", action, function(rerr, resolved)
            if not rerr and resolved and resolved.edit then
              vim.lsp.util.apply_workspace_edit(resolved.edit, "utf-8")
              fixed = fixed + 1
            end
            process_next(iteration + 1)
          end)
        end
      end)
    end

    process_next(1)
  end, vim.tbl_extend("force", opts, { desc = "Auto-fix all single-action errors" }))
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

      -- C# — RoslynExtensionsOptions surfaces StyleCop/analyzer diagnostics
      require("lspconfig").omnisharp.setup({
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/OmniSharp" },
        on_attach = lspKeySetup,
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
        settings = {
          FormattingOptions = {
            OrganizeImports = true,
          },
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
            AnalyzeOpenDocumentsOnly = false,
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
