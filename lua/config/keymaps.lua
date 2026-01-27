-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- CTRL + P usign tresitter and lsp symbols to list functions methods and classes
-- vim.keymap.set("n", "<C-p>", function()
--   require("telescope.builtin").lsp_document_symbols({
--     symbols = { "Function", "Method", "Class" },
--   })
-- end, { desc = "List functions, methods, and classes via LSP" })
-- local opts = { noremap = true, silent = true }
local opts = { noremap = true, silent = true }

vim.keymap.set(
  "n",
  "<leader>bb",
  ":Telescope buffers<CR>",
  { desc = "Telescope buffers" }
)

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
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)

-- vim.keymap.set("n", "<leader>e", function()
--   require("neo-tree.command").execute({ toggle = true, position = "float" })
-- end, { desc = "Toggle Neo-tree (float)" })
--
vim.keymap.set("n", "<leader>e", function()
  require("neo-tree.command").execute({ toggle = true, position = "float" })
end, { desc = "Toggle Neo-tree (float)" })

vim.keymap.set("n", "<C-e>", function()
  require("neo-tree.command").execute({
    action = "focus",
    position = "float",
    reveal_file = vim.fn.expand("%:p"),
  })
end, { desc = "Toggle Neo-tree (float, reveal current file)" })

-- display my markdown stuff
vim.keymap.set("n", "<leader>hh", function()
  local readme_path = vim.fn.stdpath("config") .. "/cheatcheat.md"
  vim.cmd("aboveleft split " .. readme_path)
  vim.cmd("setlocal buftype=nofile noswapfile")
end, { desc = "Display cheatcheat in split above buffer" })

local wk = require("which-key")

-- Telescope kemaps
-- Override LazyVim's <leader>sg to exclude specific folders
local ignoreList = {
  "node_modules/",
  "%.git/",
  "bin/",
  "yarn/",
  "azurite_data/",
  ".next/",
  "dist/",
  "coverage/",
  "node_modules/",
  "obj/",
}

vim.keymap.set("n", "<leader>sg", function()
  require("telescope.builtin").live_grep({
    file_ignore_patterns = ignoreList,
    additional_args = function()
      return { "--hidden", "--no-ignore" }
    end,
  })
end, { desc = "Grep (exclude node_modules, .git, bin)" })

-- Override LazyVim's <leader><leader> for find files
vim.keymap.set("n", "<leader><leader>", function()
  require("telescope.builtin").find_files({
    file_ignore_patterns = ignoreList,
    hidden = true,
    no_ignore = true,
  })
end, { desc = "Find Files (exclude node_modules, .git, bin)" })

-- Create a group description for <leader>h
wk.add({
  { "<leader>T", group = "Telescope" },
  { "<leader>Tb", ":Telescope buffers<CR>", desc = "list buffers" },
  { "<leader>TT", ":Telescope<CR>", desc = "Telescope" },
  {
    "<leader>Ts",
    ":Telescope lsp_document_symbols<CR>",
    desc = "Document Symbols",
  },
  {
    "<leader>TS",
    ":Telescope lsp_workspace_symbol<CR>",
    desc = "WorkSpace Symbols",
  },
  { "<leader>Tr", ":Telescope lsp_references<CR>", desc = "lsp_references" },
})

vim.keymap.set("n", "<C-B>", ":Telescope buffers<CR>")
vim.keymap.set("n", "<C-S>", ":Telescope lsp_document_symbols<CR>")
vim.keymap.set("n", "<C-R>", ":Telescope lsp_references<CR>")

wk.add({
  {
    "gi",
    "<cmd>lua vim.lsp.buf.implementation()<CR>",
    desc = "Go to Implementation",
  },
})

-- Create a group description for <leader>h
wk.add({
  { "<leader>h", group = "Custom Commands" },
  {
    "<leader>hk",
    ":luafile ~/.config/nvim/lua/config/keymaps.lua<CR>",
    desc = "Reload Keymaps",
  },
  { "<leader>hr", ":source $MYVIMRC<CR>", desc = "Reload Config" },
  { "<leader>hc", ":Cheatsheet", desc = "Cheatsheet" },
  -- {"<leader>hc": "':0,$ y", desc= "yank entire file"},
  { "<leader>hm", ":messages", desc = "show messages" },
  {
    "<leader>fe",
    function()
      require("neo-tree.command").execute({
        toggle = true,
        position = "float",
        action = "reveal",
      })
    end,
    desc = "Neotree reveal file",
  },
  -- { "<leader>a", ":Neotree reveal<CR>", desc = "Explorer NeoTree (reveal)" },
})

-- start a word replace with the word under the cursor with CTRl + w
vim.keymap.set("n", "<C-w>", function()
  local word = vim.fn.expand("<cword>")
  if word ~= "" then
    vim.api.nvim_feedkeys(":%s/" .. word .. "/", "n", false)
  else
    vim.api.nvim_feedkeys(":%s/", "n", false)
  end
end, { desc = "Search and Replace current word" })

-- Paste over selection without changing the default register
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without changing register" })

-- Reselect pasted text
vim.keymap.set("n", "gp", "`[v`]", { desc = "Reselect pasted text" })

-- Yank relative path of current file (available in all modes)
vim.keymap.set({ "n", "v", "i" }, "yp", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  print("Relative path copied: " .. path)
end, { desc = "Copy relative file path" })

-- Yank absolute path of current file (available in all modes)
vim.keymap.set({ "n", "v", "i" }, "yP", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("Absolute path copied: " .. path)
end, { desc = "Copy absolute file path" })

-- Escape in normal mode acts like :q
vim.keymap.set("n", "<Esc>", ":q<CR>", { desc = "Quit window" })
