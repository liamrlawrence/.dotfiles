-- The holiest of leader keys
vim.g.mapleader = " "

-- UI
vim.opt.termguicolors = true
vim.opt.guicursor:append({
    "n-v-c-sm:block",
    "i-ci-ve:ver25",
    "r-cr-o:hor20",
})
vim.opt.statusline = table.concat({
    "%<%f",
    " %h%m%r",
    "%{get(b:, 'mixed_indent', '')}",
    "%=",
    "0x%B ",
    "| %l,%c%V ",
    "| %P ",
    "| %{&filetype} ",
    "%{exists('g:repossession_session') ? '| '.g:repossession_session.' ' : ''}",
})
vim.opt.fillchars = { vert = " ", eob = "~" }
vim.opt.listchars = { leadmultispace = "·   ", tab = "  ", leadtab = "· " }
vim.opt.list = false
vim.opt.colorcolumn = "81,121"
vim.opt.scrolloff = 8

-- Gutter
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.signcolumn = "yes"

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Wrapping
vim.opt.wrap = false
vim.opt.linebreak = true

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true
vim.opt.undolevels = 100000

-- Sessions
vim.opt.sessionoptions:append({
    "blank",
    "curdir",
    "folds",
    "help",
    "tabpages",
    "winsize",
    "terminal",
    "localoptions",
})
vim.opt.shadafile = "NONE"

-- Performance
vim.opt.updatetime = 100

-- Clipboard
vim.g.clipboard = {
    name = "SSH Clipboard",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
}

