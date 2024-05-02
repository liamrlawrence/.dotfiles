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
    end,
})


function ToggleQuickfix()
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
end
vim.api.nvim_set_keymap("n", "<leader>q", ":lua ToggleQuickfix()<CR>", { silent = true })

