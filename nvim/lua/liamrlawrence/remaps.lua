local augroup = vim.api.nvim_create_augroup
local explorer_group = augroup("LL.remaps_explorer-group", { clear = true })
local highlight_group = augroup("LL.remaps_highlight-group", { clear = true })



-- Disabled
vim.keymap.set("n", "Q", "<nop>", { desc = "<Nop>" })


-- Remaps
-- vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "<C-c> is just better <Esc>" })   -- NOTE: Became enlightened, started using <C-[>


-- -- Custom :write message
-- vim.api.nvim_create_autocmd("BufWritePost", {
--     callback = function()
--         local filepath = vim.fn.expand("%:.")
--         local lines = vim.fn.line("$")
--         local timestamp = os.date("%-H:%M:%S")
--         local bytes = vim.fn.getfsize(filepath)
--         local message = string.format("\"%s\" %dL, %dB written at %s", filepath, lines, bytes, timestamp)
--         vim.api.nvim_command("redraw")  -- NOTE: Redraw avoids having to press Enter
--         vim.api.nvim_echo({{message, "None"}}, false, {})
--     end,
-- })


-- Explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Explorer" })
vim.api.nvim_create_autocmd("FileType", {
    desc = "Line numbers for netrw",
    group = explorer_group,
    pattern = "netrw",
    callback = function()
        vim.wo.nu = true
        vim.wo.relativenumber = true
    end,
})


-- Movements
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv",    { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv",    { desc = "Move line up" })
vim.keymap.set("n", "J", function() -- "mzJ`z"
    local saved_pos = vim.fn.getpos(".")
    vim.cmd(":normal! J")
    vim.fn.setpos(".", saved_pos)
end, { desc = "J does not move cursor" })


-- Jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center on half-page jumps" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center on half-page jumps" })
vim.keymap.set("n", "n", "nzzzv",       { desc = "Center on search jumps"})
vim.keymap.set("n", "N", "Nzzzv",       { desc = "Center on search jumps" })


-- Folds
vim.keymap.set("n", "zR", "zRzz", { desc = "Open all folds in file" })
vim.keymap.set("n", "zM", "zMzz", { desc = "Close all folds in file" })


-- Highlights
-- vim.keymap.set("n", "<leader>/h", vim.cmd.noh, { desc = "Clear highlights" })    -- NOTE: Can use <C-l> instead
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = highlight_group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

local function highlight_visual_mode(key)
    local original_visual_highlight = vim.api.nvim_get_hl_by_name("Visual", true)
    local incsearch_highlight = vim.api.nvim_get_hl_by_name("IncSearch", true)

    vim.api.nvim_set_hl(0, "Visual", incsearch_highlight)
    vim.cmd("normal! " .. key)

    local autocmd_id
    autocmd_id = vim.api.nvim_create_autocmd("ModeChanged", {
        desc = "Remove custom highlighting from visual mode on exit",
        group = highlight_group,
        pattern = "*",
        callback = function()
            local old_mode = vim.v.event.old_mode
            local new_mode = vim.v.event.new_mode

            local visual_modes = {
                ['v'] = true,
                ['V'] = true,
                [string.char(22)] = true,   -- NOTE: Ctrl-V is char(22)
            }

            -- Check if we have left Visual mode entirely
            if visual_modes[old_mode] and not visual_modes[new_mode] then
                vim.api.nvim_set_hl(0, "Visual", original_visual_highlight)
                vim.api.nvim_del_autocmd(autocmd_id)
            end
        end,
    })
end
vim.keymap.set("n", "<leader>v", function() highlight_visual_mode("v") end, { desc = "Enter visual mode with highlighting" })
vim.keymap.set("n", "<leader>V", function() highlight_visual_mode("V") end, { desc = "Enter Visual mode with highlighting" })


-- Yanks
vim.keymap.set("n", "yY",         [[:%y<CR>]],  { desc = "Yank entire file" })
vim.keymap.set("n", "<leader>yY", [[:%y+<CR>]], { desc = "Yank entire file to clipboard" })
vim.keymap.set("n", "<leader>y",  [["+y]],      { desc = "Yank to clipboard" })
vim.keymap.set("v", "<leader>y",  [["+y]],      { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y",  [["+yg_]],    { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>yd", function()
    local diagnostics = vim.diagnostic.get(0)
    local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local messages = {}

    for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.lnum == current_line then
            table.insert(messages, diagnostic.message)
        end
    end

    if #messages == 0 then
        return
    elseif #messages == 1 then
        vim.fn.setreg("+", messages[1])
    else
        vim.ui.select(messages, { prompt = "Select a diagnostic message to yank (or press Enter to yank all):" }, function(choice)
            if not choice then
                vim.fn.setreg("+", table.concat(messages, "\n"))
            else
                vim.fn.setreg("+", choice)
            end
        end)
    end
end, { desc = "Yank diagnostics from current line to clipboard" })


-- Deletes
vim.keymap.set("n", "<leader>d", [["_d]],   { desc = "Don't save deleted text to buffer" })
vim.keymap.set("v", "<leader>d", [["_d]],   { desc = "Don't save deleted text to buffer" })
vim.keymap.set("x", "<leader>p", [["_dP]],  { desc = "Don't save deleted text to buffer" })


-- Quickfix list
vim.keymap.set("n", "<C-j>",     "<cmd>cnext<CR>zz",    { desc = "Next quickfix" })
vim.keymap.set("n", "<C-k>",     "<cmd>cprev<CR>zz",    { desc = "Prev quickfix" })
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz",    { desc = "Next location list fix" })
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz",    { desc = "Prev location list fix" })
vim.keymap.set("n", "<leader>q", function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            vim.cmd("cclose")
            return
        end
    end
    vim.cmd("copen")
end, { desc = "Toggle quickfix list" })


-- Text replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Global text replace" })
vim.keymap.set("n", "<leader>S", [[:.s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Line text replace" })


-- Editor
vim.keymap.set("n", "<leader>ew", function()
    vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrapping" })

vim.keymap.set("n", "<leader>er", function()
    vim.wo.nu = true
    vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })

vim.keymap.set("n", "<leader>e=", function() -- "mzgg=G`z"
    local saved_pos = vim.fn.getpos(".")
    vim.cmd(":normal! =lgg=G")              -- NOTE: =l prevents undo/redo from jumping to the top of the file
    vim.fn.setpos(".", saved_pos)
end, { desc = "Reindent file" })

