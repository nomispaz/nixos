vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({"n","v"}, "<Space>", "<Nop>", { silent = true })

local opt = vim.opt

vim.g.autoformat = true

opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = false -- highlighting of the current line
--opt.expandtab = true -- Use spaces instead of tabs
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
vim.wo.relativenumber = true
opt.scrolloff = 4 -- Lines of context
opt.shiftround = true -- Round indent
--opt.shiftwidth = 4 -- Size of an indent
opt.showmode = false -- Dont show mode since we have a statusline
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wrap = true -- line wrap
opt.conceallevel = 2 --conceal links
opt.concealcursor = 'nc'
opt.completeopt = {'menu', 'menuone', 'noselect'} --autocomplete selection

require("config.autocommands")
require("config.functions")
require("config.keymaps")

require("config.lazy")

vim.cmd.colorscheme "catppuccin-mocha"
--vim.cmd.colorscheme "tokyonight-night"
