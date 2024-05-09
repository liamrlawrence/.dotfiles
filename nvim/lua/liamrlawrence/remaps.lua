local augroup = vim.api.nvim_create_augroup
local explorerGroup = augroup("explorer-group", {})
local highlightGroup = augroup("highlight-group", { clear = true })


-- The holiest of leader keys
vim.g.mapleader = " "


-- Disabled
vim.keymap.set("n", "Q", "<nop>", { desc = "nop" })


-- Explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Explorer" })
vim.api.nvim_create_autocmd("FileType", {
    desc = "Line numbers for netrw",
    group = explorerGroup,
    pattern = "netrw",
    callback = function()
        vim.wo.relativenumber = true
    end
})


-- Movements
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv",    { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv",    { desc = "Move line up" })
vim.keymap.set("n", "J", "mzJ`z",               { desc = "J does not move cursor" })


-- Jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center on half-page jumps" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center on half-page jumps" })
vim.keymap.set("n", "n", "nzzzv",       { desc = "Center on search jumps"})
vim.keymap.set("n", "N", "Nzzzv",       { desc = "Center on search jumps" })


-- Highlights
vim.keymap.set("n", "<leader>/h", vim.cmd.noh, { desc = "Clear highlights" })
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = highlightGroup,
    callback = function()
        vim.highlight.on_yank()
    end
})


-- Deletes
vim.keymap.set("x", "<leader>p", "\"_dP",   { desc = "Don't save deleted text to buffer" })
vim.keymap.set("n", "<leader>d", "\"_d",    { desc = "Don't save deleted text to buffer" })
vim.keymap.set("v", "<leader>d", "\"_d",    { desc = "Don't save deleted text to buffer" })


-- Yanks
vim.keymap.set("n", "<leader>y", "\"+y",        { desc = "Yank to clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y",        { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y",        { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>yY", ":%y+<CR>",   { desc = "Yank entire file to clipboard" })
vim.keymap.set("n", "yY",         ":%y<CR>",    { desc = "Yank entire file" })


-- Quickfix list
vim.keymap.set("n", "<C-k>",     "<cmd>cnext<CR>zz",    { desc = "Next quickfix" })
vim.keymap.set("n", "<C-j>",     "<cmd>cprev<CR>zz",    { desc = "Prev quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz",    { desc = "Next location list fix" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz",    { desc = "Prev location list fix" })
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
end, { desc = "Toggle quickfix list", silent = true })


-- Text replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Global text replace" })
vim.keymap.set("n", "<leader>S", [[:.s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Line text replace" })


-- Editor
vim.keymap.set("n", "<leader>ew", function() vim.wo.wrap = not vim.wo.wrap end, { desc = "Toggle line wrapping", silent = true })
vim.keymap.set("n", "<leader>er", function()
    vim.wo.nu = true
    vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers", silent = true })
