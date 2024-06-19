-- The holiest of leader keys
vim.g.mapleader = " "


vim.opt.guicursor = ""
vim.opt.fillchars = { vert = " ", eob = "~" }

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.shadafile = "NONE"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.undolevels = 100000

vim.opt.inccommand = "split"
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.termguicolors = true

