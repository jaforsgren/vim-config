-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--

-- Highlight on yank
-- TODO: crashes :(
-- api.nvim_create_autocmd("TextYankPost", {
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })

-- go to last loc when opening a buffer
-- this mean that when you open a file, you will be at the last position
-- api.nvim_create_autocmd("BufReadPost", {
--   callback = function()
--     local mark = vim.api.nvim_buf_get_mark(0, '"')
--     local lcount = vim.api.nvim_buf_line_count(0)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })

-- Enable spell checking for certain file types
-- api.nv im_create_autocmd(
--   { "BufRead", "BufNewFile" },
--   -- { pattern = { "*.txt", "*.md", "*.tex" }, command = [[setlocal spell<cr> setlocal spelllang=en,de<cr>]] }
--   {
--     pattern = { "*.txt", "*.md", "*.tex" },
--     callback = function()
--       vim.opt.spell = true
--       vim.opt.spelllang = "en,de"
--     end,
--   }
-- )

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- macOS requires ad-hoc code signatures on dlopen'd .so files (treesitter parsers).
-- Re-sign after TSUpdate or Lazy updates to prevent SIGKILL on parser load.
vim.api.nvim_create_autocmd("User", {
  pattern = { "TSUpdate", "LazyUpdatePost" },
  callback = function()
    local parser_dirs = {
      vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser",
      vim.fn.stdpath("data") .. "/site/parser",
    }
    for _, dir in ipairs(parser_dirs) do
      local files = vim.fn.glob(dir .. "/*.so", false, true)
      for _, f in ipairs(files) do
        vim.fn.jobstart({ "codesign", "--force", "-s", "-", f })
      end
    end
  end,
})

local go_fmt_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
  group = go_fmt_grp,
})

