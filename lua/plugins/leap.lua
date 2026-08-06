return {
  {
    "https://codeberg.org/andyg/leap.nvim.git",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
}
