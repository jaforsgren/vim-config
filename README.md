# My LazyVim Configuration

This is my customized Neovim setup using LazyVim as the base. Below are the plugins, customizations, and configurations I've added or modified.

---

## Plugins

### Core Plugins

- [LazyVim](https://github.com/LazyVim/LazyVim) - The base configuration.
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager used by LazyVim.

### Theme and Appearance

- [Mofiqul/adwaita.nvim](https://github.com/Mofiqul/adwaita.nvim) - **Primary theme** with custom highlights:
  - Darker version enabled.
  - Transparent background.
  - Cursorline enabled.
  - `TelescopeSelection` customized for better visibility.
- [bluz71/vim-moonfly-colors](https://github.com/bluz71/vim-moonfly-colors) - Additional theme, but not actively used.

### UI Enhancements

- [folke/noice.nvim](https://github.com/folke/noice.nvim) - Enhanced command-line and notifications:
  - Command-line view set to `cmdline`.
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Statusline with a sleek look.
- [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Tabs and buffer management.
- [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - Indentation guides.

### LSP and Development

- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Core LSP configurations.
- [jose-elias-alvarez/typescript.nvim](https://github.com/jose-elias-alvarez/typescript.nvim) - TypeScript LSP features with custom keybindings:
  - `gd` for go-to definition.
  - `K` for hover.
  - `<leader>rn` for rename.
  - `<leader>ca` for code actions.
- [nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) - Text object enhancements for Treesitter.
- [windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) - Automatic tag completion for HTML/JSX.
- [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint) - Linting support.

### Productivity

- [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim) - Highlight and search for `TODO` comments.
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim) - A better diagnostics list.

### Miscellaneous

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Enhanced syntax highlighting.
- [vim-repeat](https://github.com/tpope/vim-repeat) - Enhance repeatable actions.
- [mini.nvim](https://github.com/echasnovski/mini.nvim) - Minimalist Neovim enhancements:
  - `mini.ai` for improved text objects.
  - `mini.pairs` for automatic pairing.

---

## Customizations

### Theme

- **Adwaita Theme Configuration**:
  - Enabled darker mode and transparency.
  - Customized highlights for `TelescopeSelection`:
    ```lua
    vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = "#ffffff", bg = "#44475a", bold = true })
    ```

### LSP Keybindings

- `gd`: Go to definition.
- `K`: Show hover documentation.
- `<leader>rn`: Rename symbol.
- `<leader>ca`: Code actions.
