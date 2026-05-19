-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
-- vim.cmd.colorscheme("adwaita")
--
--
--
--
--
--

-- virtual_text disabled here — tiny-inline-diagnostic handles inline display
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
})
