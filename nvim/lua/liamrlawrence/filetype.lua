vim.filetype.add({
    extension = {
        templ = "templ",    -- Golang templ files
    },
    filename = {
        [".dockerignore"] = "gitignore",
    },
    pattern = {
        ["*%.env.*"] = "sh",
        [".*%.gitignore.*"] = "gitignore",
        [".*Dockerfile.*"] = "dockerfile",
    },
})


-- Smaller tabs for HTML files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "html",
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end
})


-- Use hard-tabs for Go files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
    end
})

-- Run 'go fmt' (or LSP format) after saving Go files
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    command = "silent! lua vim.lsp.buf.format()"
})

