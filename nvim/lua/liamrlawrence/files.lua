local augroup = vim.api.nvim_create_augroup
local all_files_group = augroup("LL.files_all-group", { clear = true })
local git_files_group = augroup("LL.files_git-group", { clear = true })
local python_files_group = augroup("LL.files_python-group", { clear = true })
local cc_files_group = augroup("LL.files_cc-group", { clear = true })
local go_files_group = augroup("LL.files_go-group", { clear = true })
local rust_files_group = augroup("LL.files_rust-group", { clear = true })
local html_files_group = augroup("LL.files_html-group", { clear = true })
local css_files_group = augroup("LL.files_css-group", { clear = true })
local json_files_group = augroup("LL.files_json-group", { clear = true })
local org_files_group = augroup("LL.files_org-group", { clear = true })
local make_files_group = augroup("LL.files_make-group", { clear = true })



vim.filetype.add({
    extension = {
        --
    },
    filename = {
        --
    },
    pattern = {
        --
    },
})


-- All files
vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Remove trailing whitespace on write",
    group = all_files_group,
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})


-- C/C++
local c_file_patterns = { "*.c", "*.h", }
local cpp_file_patterns = { "*.cc", "*.hh", "*.cpp", "*.hpp", }
local cc_file_patterns = vim.list_extend(vim.list_extend({}, c_file_patterns), cpp_file_patterns)

vim.api.nvim_create_autocmd("FileType", {
    desc = "C/C++ file settings",
    group = cc_files_group,
    pattern = cc_file_patterns,
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 8
        vim.bo.tabstop = 8
    end,
})

-- C++
vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Format C++ files with 'clang-format' before saving",
    group = cc_files_group,
    pattern = cpp_file_patterns,
    callback = function()
        vim.lsp.buf.format({ async = false, name = "clangd" })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Update 'Updated:' date in C++ file header comments",
    group = cc_files_group,
    pattern = cpp_file_patterns,
    callback = function()
        if not vim.bo.modified then return end
        local lines = vim.api.nvim_buf_get_lines(0, 0, 15, false)   -- Only look at first 15 lines
        for i, line in ipairs(lines) do
            if line:match("^// Updated%s*:") then
                local today = os.date("%B %-d, %Y") --[[@as string]]
                if line:find(today, 1, true) then break end
                local new_line = line:gsub("(// Updated%s*:%s*).*", "%1" .. today)
                vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
                break
            end
        end
    end
})


-- Python
vim.api.nvim_create_autocmd("FileType", {
    desc = "Python file settings",
    group = python_files_group,
    pattern = "python",
    callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
    end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
    desc = "Run 'black' after saving Python files",
    group = python_files_group,
    pattern = "*.py",
    callback = function()
        -- local file = vim.fn.expand('%')
        -- vim.fn.system("black -q " .. file)
        -- vim.cmd("edit!")    -- Re-read the file to reflect the changes
    end,
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
    desc = "Format go files with 'go fmt' before saving",
    group = go_files_group,
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
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


-- Rust
vim.api.nvim_create_autocmd("FileType", {
    desc = "Rust file settings",
    group = rust_files_group,
    pattern = "rust",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.shiftwidth = 8
        vim.bo.tabstop = 8
    end,
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
        local saved_pos = vim.fn.getpos(".")
        vim.cmd(":normal! =lgg=G")      -- TODO: Why can't I use '<leader>e='?
        vim.fn.setpos(".", saved_pos)
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


-- Git
vim.api.nvim_create_autocmd("FileType", {
    desc = "Git commit message formatting",
    group = git_files_group,
    pattern = "gitcommit",
    callback = function()
        vim.wo.colorcolumn = "51,73"
        vim.fn.matchadd("WarningMsg", [[\%1l\%>50v.*]])         -- yellow 51+
        vim.fn.matchadd("ErrorMsg",   [[\%1l\%>72v.*]], 11)     -- red 73+
        vim.fn.matchadd("ErrorMsg",   [[\%2l.*]])               -- red line 2
    end,
})

