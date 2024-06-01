local augroup = vim.api.nvim_create_augroup
local allFilesGroup = augroup("LL_all-files-group", {})
local goFilesGroup = augroup("LL_go-files-group", {})
local htmlFilesGroup = augroup("LL_html-files-group", {})
local cssFilesGroup = augroup("LL_css-files-group", {})
local jsonFilesGroup = augroup("LL_json-files-group", {})
local orgFilesGroup = augroup("LL_org-files-group", {})
local makeFilesGroup = augroup("LL_make-files-group", {})



vim.filetype.add({
    extension = {
        templ = "templ",    -- Golang templ files
    },
    filename = {
        [".dockerignore"] = "gitignore",
    },
    pattern = {
        ["*%.env.*"]        = "sh",
        [".*%.gitignore$"]  = "gitignore",
        [".*%.ignore$"]     = "gitignore",
        [".*Dockerfile.*"]  = "dockerfile",
    },
})


-- All files
vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Remove trailing whitespace from files",
    group = allFilesGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})


-- Go
vim.api.nvim_create_autocmd("FileType", {
    desc = "Go file settings",
    group = goFilesGroup,
    pattern = "go",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 8
        vim.bo.tabstop = 8
    end
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Run 'go fmt' after saving Go files",
    group = goFilesGroup,
    pattern = "*.go",
    command = "silent! lua vim.lsp.buf.format()"
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Templ file settings",
    group = goFilesGroup,
    pattern = "templ",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.commentstring = "<!--%s-->"
    end
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Rebuild Go templ files on save",
    group = goFilesGroup,
    pattern = "*.templ",
    command = "silent! templ generate"
})


-- Web
vim.api.nvim_create_autocmd("FileType", {
    desc = "HTML file settings",
    group = htmlFilesGroup,
    pattern = "html",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
    end
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "CSS file settings",
    group = cssFilesGroup,
    pattern = "css",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
    end
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "JSON file settings",
    group = jsonFilesGroup,
    pattern = "json",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
    end
})


-- Org files
vim.api.nvim_create_autocmd("FileType", {
    desc = "Org file settings",
    group = orgFilesGroup,
    pattern = "org",
    callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
    end
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Format org files on save",
    group = goFilesGroup,
    pattern = "*.org",
    command = ":normal! <space>e=",
})


-- Makefiles
vim.api.nvim_create_autocmd("FileType", {
    desc = "Makefile settings",
    group = makeFilesGroup,
    pattern = "make",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 8
        vim.bo.tabstop = 8
    end
})

