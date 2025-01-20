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

-- paste over currently selected text without yanking it
-- vim.keymap.set("v", "p", '"_dp')
-- vim.keymap.set("v", "P", '"_dP')§:
