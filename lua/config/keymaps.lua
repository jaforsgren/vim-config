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

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>bb", ":Telescope buffers<CR>", { desc = "Telescope buffers" })

-- vim.keymap.set("n", "<C-o>", ":Telescope buffers<CR>")
-- vim.keymap.set("n", "<C-k>", ":Neotree reveal<CR>")

-- vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Telescope lsp lsp_references" })
-- vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, { desc = "Telescope lsp lsp_references" })
--

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
--
vim.keymap.set("n", "<leader>a", function()
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
  { "<leader>bb", ":Telescope buffers<CR>", desc = "list buffers" },
  { "<leader>hk", ":luafile ~/.config/nvim/lua/config/keymaps.lua<CR>", desc = "Reload Keymaps" },
  { "<leader>hr", ":source $MYVIMRC<CR>", desc = "Reload Config" },
  -- {"<leader>hc": "':0,$ y", desc= "yank entire file"},
  { "<leader>hm", ":messages", desc = "show messages" },
  {
    "<leader>fo",
    require("neo-tree.command").execute({ toggle = true, position = "float", action = "reveal" }),
    desc = "Neotree reveal file",
  },
  { "<leader>a", ":Neotree reveal<CR>", desc = "Explorer NeoTree (reveal)" },
})
