-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.options")
require("config.keymaps")
require("dap-python").setup("python3")

local opt = vim.opt
vim.g.mapleader = " "

opt.autoindent = true
opt.backup = false
opt.completeopt = "menu,menuone,noselect" -- needed for cmp nvim
opt.diffopt = "internal,filler,closeoff,vertical"
opt.expandtab = true
opt.fileformats = "unix"
opt.fileignorecase = true
opt.fillchars = "vert:|"
opt.grepformat:append("%f:%l:%c:%m,%f:%l:%m")
opt.grepprg = "rg --vimgrep --no-heading --hidden"
opt.hidden = true -- dont unload abandoned buffers, just hide em
opt.ignorecase = true
opt.laststatus = 1
opt.listchars = "tab:>--,space:·,trail:·" -- chars in :list mode
opt.number = true
opt.path:append("**,bin/.local/**,nvim/.config/**,vim/.vim/**,tmux/.**")
opt.relativenumber = true
opt.scrolloff = 5
opt.shiftround = true
opt.shiftwidth = 2
opt.showcmd = false
opt.sidescrolloff = 5
opt.signcolumn = "yes:1"
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 2
opt.swapfile = false
opt.termguicolors = true
opt.timeoutlen = 500 --timeout for mappings
opt.undofile = true -- uses the default undodir "~/.local/share/nvim/undo
opt.updatetime = 100 --updatetime for events
opt.wildignore = "*/node_modules/**,*/elm-stuff/**"
opt.wildmenu = true
opt.wildmode = "lastused:list:full"
opt.wrap = false

-- vim.cmd.colorscheme("adwaita")
vim.cmd([[hi NormalFloat guibg=#18 guifg=#aaaaaa]])
--
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.cs",
--   callback = function()
--     vim.lsp.buf.format({
--       async = false, -- synchronous formatting ensures save respects it
--       filter = function(client)
--         return client.name == "omnisharp"
--       end,
--     })
--   end,
-- })
--
--

-- vim.env.PATH = vim.env.PATH .. ":/usr/local/share/dotnet"
vim.env.PATH = vim.env.PATH .. ":/opt/homebrew/opt/dotnet@9/libexec"
vim.env.DOTNET_ROOT = "/opt/homebrew/opt/dotnet@9/libexec"
