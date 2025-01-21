-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
-- nnoremap <F5> :buffers<CR>:buffer<Space>
--
--

-- CTRL + P usign tresitter and lsp symbols to list functions methods and classes
vim.keymap.set("n", "<C-p>", function()
  require("telescope.builtin").lsp_document_symbols({
    symbols = { "Function", "Method", "Class" },
  })
end, { desc = "List functions, methods, and classes via LSP" })

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Remap for dealing with visual line wraps
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move selected line / block of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG", opts)

-- display my markdown stuff
vim.keymap.set("n", "<leader>hh", function()
  local readme_path = vim.fn.stdpath("config") .. "/cheatcheat.md"
  vim.cmd("aboveleft split " .. readme_path)
  vim.cmd("setlocal buftype=nofile noswapfile")
end, { desc = "Display cheatcheat in split above buffer" })

-- Create a group description for <leader>h
local wk = require("which-key")
wk.add({
  { "<leader>h", group = "Custom Commands" },
  { "<leader>hk", ":luafile ~/.config/nvim/lua/config/keymaps.lua<CR>", desc = "Reload Keymaps" },
  { "<leader>hr", ":source $MYVIMRC<CR>", desc = "Reload Config" },
  { "<leader>hm", ":messages", desc = "show messages" },
})

-- DAP stuff
local dap = require("dap")
local vscode = require("dap.ext.vscode")

if vim.fn.filereadable(".vscode/launch.json") then
  require("dap.ext.vscode").load_launchjs(nil, { cpptools = { "c", "cpp" } })
end

wk.add({
  { "<F5>", dap.continue, desc = "Start/Continue Debugging" },
  { "<F10>", dap.step_over, desc = "Step Over" },
  { "<F11>", dap.step_into, desc = "Step Into" },
  { "<F12>", dap.step_out, desc = "Step Out" },
  { "<leader>db", dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
  { "<leader>dl", dap.run_last, desc = "Run Last Debug Session" },
  { "<leader>dr", dap.repl.open, desc = "Open REPL" },
  { "<leader>dt", dap.terminate, desc = "Terminate Debug Session" },
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
  -- { "du", require("dapui").toggle, desc = "Toggle Debug UI" },
})

-- paste over currently selected text without yanking it
-- vim.keymap.set("v", "p", '"_dp')
-- vim.keymap.set("v", "P", '"_dP')§:
