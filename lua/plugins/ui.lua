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
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      no_italic = true,
      term_colors = true,
      transparent_background = false,
      styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
      },
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
        },
      },
      integrations = {
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        dropbar = {
          enabled = true,
          color_mode = true,
        },
      },
    },
  },
  { "marko-cerovac/material.nvim" },
  {
    "sudormrfbin/cheatsheet.nvim",

    requires = {
      { "nvim-telescope/telescope.nvim" },
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
  },
}
