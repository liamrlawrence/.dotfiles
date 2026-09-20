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

function __LazyVirtualPlugin(spec)
    local name = spec[1]:match("([^/]+)$")
    local dir = vim.fn.stdpath("data") .. "/lazy.virtual-plugins/" .. name
    if not vim.uv.fs_stat(dir) then vim.fn.mkdir(dir, "p") end
    spec.dir = dir
    return spec
end

require("lazy").setup({
    spec = {
        { import = "liamrlawrence.plugins.editing" },
        { import = "liamrlawrence.plugins.git"     },
        { import = "liamrlawrence.plugins.ide"     },
        { import = "liamrlawrence.plugins.lang"    },
        { import = "liamrlawrence.plugins.org"     },
        { import = "liamrlawrence.plugins.project" },
        { import = "liamrlawrence.plugins.ui"      },
    },
    change_detection = { notify = false }
})

