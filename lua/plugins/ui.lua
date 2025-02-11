return {
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline", -- Default command-line behavior
      },
    },
  },
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "Mofiqul/adwaita.nvim",
    lazy = false,
    priority = 1000,

    -- configure and set on startup
    config = function()
      vim.g.adwaita_darker = true -- for darker version
      vim.g.adwaita_disable_cursorline = false -- to disable cursorline
      vim.g.adwaita_transparent = true -- makes the background transparent
      vim.cmd("colorscheme adwaita")
      vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#ffffff", bg = "#44475a", bold = true })
    end,
  },
}
