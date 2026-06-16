local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.lazy_virtual_plugin = vim.fn.stdpath("data") .. "/virtual-plugin.lazy"
vim.fn.mkdir(vim.g.lazy_virtual_plugin, "p")

require("lazy").setup({
    spec = "liamrlawrence.plugins",
    change_detection = { notify = false }
})

