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

vim.keymap.set("n", "<leader>e", function()
  require("neo-tree.command").execute({ toggle = true, position = "float" })
end, { desc = "Toggle Neo-tree (float)" })

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
  -- {"<leader>hc": "':0,$ y", desc= "yank entire file"},
  { "<leader>hm", ":messages", desc = "show messages" },
})

-- DAP stuff
-- local dap = require("dap")
-- local dapui = require("dapui")
-- local vscode = require("dap.ext.vscode")
-- local dapwidgets = require("dap.ui.widgets")
-- --

-- wk.
--       vscode.load_launchjs(nil, {})
--       print("Loaded VS Code launch.json configurations")
--     end,
--     desc = "Load Debug Config from launch.json",
--   },
--   {
--     "<leader>dv",
--     function()
--       vscode.load_launchjs(nil, {})
--       print("Loaded VS Code launch.json configurations")
--       dap.continue()
--     end,
--     desc = "Load Debug Config from launch.json",
--   },
--   {
--     "<leader>dB",
--     function()
--       dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
--     end,
--     desc = "Set Conditional Breakpoint",
--   },
--   {
--     "<leader>dh",
--     function()
--       dapwidgets.hover(nil, { use_visual_selection = true })
--     end,
--     desc = "hover widgets",
--   },
--   { "<leader>dh", dapwidgets.preview, desc = "preview widgets" },
--   {
--     "<leader>dc",
--     function()
--       dapwidgets.float_element("console")
--     end,
--     desc = "float console",
--   },
--
--   {
--     "<leader>dw",
--     function()
--       dapwidgets.centered_float(dapwidgets.scopes)
--     end,
--     desc = "float scopes",
--   },
--   {
--     "<leader>de",
--     function()
--       dapwidgets.centered_float(dapwidgets.expression)
--     end,
--     desc = "float expression",
--   },
--   {
--     "<leader>df",
--     function()
--       dapwidgets.centered_float(dapwidgets.frames)
--     end,
--     desc = "float frames",
--   },
-- })

--   -- configure widgets
--
--       local widgets = require('dap.ui.widgets')
--
--       -- set scopes as right pane
--       local scopes = widgets.sidebar(widgets.scopes, {}, 'vsplit')
--
--       -- set frames as bottom pane
--       local frames = widgets.sidebar(widgets.frames, {height = 10}, 'belowright split')
--
--       vim.keymap.set('n', '<leader>dj', dap.continue)
--       vim.keymap.set('n', '<leader>dm', dap.step_over)
--       vim.keymap.set('n', '<leader>di', dap.step_into)
--       vim.keymap.set('n', '<leader>dk', dap.toggle_breakpoint)
--       vim.keymap.set('n', '<leader>dn', dap.clear_breakpoints)
--       vim.keymap.set('n', '<leader>dt', dap.terminate)
