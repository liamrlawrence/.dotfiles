local augroup = vim.api.nvim_create_augroup
local all_files_group = augroup("LL.files_all-group", { clear = true })
local go_files_group = augroup("LL.files_go-group", { clear = true })
local html_files_group = augroup("LL.files_html-group", { clear = true })
local css_files_group = augroup("LL.files_css-group", { clear = true })
local json_files_group = augroup("LL.files_json-group", { clear = true })
local org_files_group = augroup("LL.files_org-group", { clear = true })
local make_files_group = augroup("LL.files_make-group", { clear = true })



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
    group = all_files_group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})


-- Go
vim.api.nvim_create_autocmd("FileType", {
    desc = "Go file settings",
    group = go_files_group,
    pattern = "go",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 8
        vim.bo.tabstop = 8
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Run 'go fmt' after saving Go files",
    group = go_files_group,
    pattern = "*.go",
    command = "silent! lua vim.lsp.buf.format()",
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Templ file settings",
    group = go_files_group,
    pattern = "templ",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Rebuild Go templ files on save",
    group = go_files_group,
    pattern = "*.templ",
    command = "silent! templ generate",
})


-- Web
vim.api.nvim_create_autocmd("FileType", {
    desc = "HTML file settings",
    group = html_files_group,
    pattern = "html",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "CSS file settings",
    group = css_files_group,
    pattern = "css",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "JSON file settings",
    group = json_files_group,
    pattern = "json",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
    end,
})


-- Org files
vim.api.nvim_create_autocmd("FileType", {
    desc = "Org file settings",
    group = org_files_group,
    pattern = "org",
    callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Format org files on save",
    group = org_files_group,
    pattern = "*.org",
    callback = function()
        vim.cmd(":normal! =lggVG=")     -- TODO: Why can't I use '<leader>e='?
    end,
})


-- Makefiles
vim.api.nvim_create_autocmd("FileType", {
    desc = "Makefile settings",
    group = make_files_group,
    pattern = "make",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 8
        vim.bo.tabstop = 8
    end,
})

