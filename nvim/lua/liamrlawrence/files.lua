local augroup = vim.api.nvim_create_augroup
local allFilesGroup = augroup("all-files-group", {})
local goFilesGroup = augroup("go-files-group", {})
local htmlFilesGroup = augroup("html-files-group", {})
local cssFilesGroup = augroup("css-files-group", {})



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



vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Remove trailing whitespace from files",
    group = allFilesGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})


-- Web
vim.api.nvim_create_autocmd("FileType", {
    desc = "Tabs for HTML files",
    group = htmlFilesGroup,
    pattern = "html",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
    end
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Tabs for CSS files",
    group = cssFilesGroup,
    pattern = "css",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
    end
})


-- Go
vim.api.nvim_create_autocmd("FileType", {
    desc = "Tabs for Go files",
    group = goFilesGroup,
    pattern = "go",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.tabstop = 8
        vim.bo.shiftwidth = 8
    end
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Run 'go fmt' after saving Go files",
    group = goFilesGroup,
    pattern = "*.go",
    command = "silent! lua vim.lsp.buf.format()"
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Rebuild Go templ files on save",
    group = goFilesGroup,
    pattern = "*.templ",
    command = "silent! templ generate"
})

