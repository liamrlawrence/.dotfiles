require("liamrlawrence.set")
require("liamrlawrence.remap")
require("liamrlawrence.files")
require("liamrlawrence.lazy_init")
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup


vim.api.nvim_create_autocmd("FileType", {
    desc = "Line numbers for netrw",
    group = augroup("netrw-group", {}),
    pattern = "netrw",
    callback = function()
        vim.wo.relativenumber = true
    end
})


vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = augroup("highlight-group", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end
})


vim.keymap.set("n", "<leader>q", function()
    local is_quickfix_open = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            is_quickfix_open = true
            break
        end
    end
    if is_quickfix_open then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end, { silent = true, desc = "Toggle quickfix list" })


vim.keymap.set("n", "<leader>er", function()
    vim.wo.nu = true
    vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers", silent = true })

vim.keymap.set("n", "<leader>ew", function()
    vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrapping", silent = true })

