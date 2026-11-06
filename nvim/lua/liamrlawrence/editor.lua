local augroup = vim.api.nvim_create_augroup
local highlight_group = augroup("LL.editor_highlight-group", { clear = true })
local yank_group      = augroup("LL.editor_yank-group",      { clear = true })



-- Save
vim.keymap.set("n", "ZA", "<Cmd>confirm wqa<CR>", { desc = "Write-Quit-All" })


-- Tabs
vim.keymap.set("n", "<Tab>",            "<Cmd>tabnext<CR>",           { desc = "Next tab" })
vim.keymap.set("n", "<S-Tab>",          "<Cmd>tabprev<CR>",           { desc = "Prev tab" })
vim.keymap.set("n", "<M-Tab>",          "<Cmd>silent! +tabmove<CR>",  { desc = "Move the current tab right" })
vim.keymap.set("n", "<M-S-Tab>",        "<Cmd>silent! -tabmove<CR>",  { desc = "Move the current tab left" })
vim.keymap.set("n", "<Leader><Tab>n",   "<Cmd>tabnew<CR>",            { desc = "New tab" })
vim.keymap.set("n", "<Leader><Tab>f",   "<Cmd>tabnew<CR><Leader>/f",  { desc = "New tab with file picker", remap = true })
vim.keymap.set("n", "<Leader><S-Tab>n", "<Cmd>-tabnew<CR>",           { desc = "New tab (behind)" })
vim.keymap.set("n", "<Leader><S-Tab>f", "<Cmd>-tabnew<CR><Leader>/f", { desc = "New tab (behind) with file picker", remap = true })


-- Line manipulation
vim.keymap.set("x", "J", function() return ":m '>+" .. vim.v.count1     .. "<CR>gv=gv" end, { expr = true, desc = "Move line down" })
vim.keymap.set("x", "K", function() return ":m '<-" .. vim.v.count1 + 1 .. "<CR>gv=gv" end, { expr = true, desc = "Move line up" })
vim.keymap.set("n", "J", function() -- "mzJ`z"
    local view = vim.fn.winsaveview()
    vim.cmd(":normal! " .. vim.v.count1 .. "J")
    vim.fn.winrestview(view)
end, { desc = "J does not move cursor" })


-- Jumps
vim.keymap.set("n", "n",     "nzzzv",   { desc = "Center on search jumps" })
vim.keymap.set("n", "N",     "Nzzzv",   { desc = "Center on search jumps" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center on half-page jumps" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center on half-page jumps" })
vim.keymap.set("n", "<C-i>", "<C-i>",   { desc = "Jump forward in jumplist" })  -- FIX: <Tab> and <C-i> are the same keycode in legacy terminals;
                                                                                -- once the kitty protocol disambiguates them, mapping <Tab>
                                                                                -- clobbers <C-i>, so manually reassert it.
-- Folds
vim.keymap.set("n", "zR",         "zRzz",  { desc = "Open all folds in file" })
vim.keymap.set("n", "zM",         "zMzz",  { desc = "Close all folds in file" })
vim.keymap.set("n", "<Leader>fm", "vimzf", { desc = "Fold function", remap = true })


-- Highlights
vim.keymap.set("n", "<Leader>/h", vim.cmd.noh, { desc = "Clear highlights" })   -- NOTE: Can use <C-l> instead
vim.api.nvim_create_autocmd({ "TextYankPost", "TextPutPost" }, {
    desc = "Highlight yanked and put text",
    group = highlight_group,
    callback = function()
        vim.hl.hl_op()
    end,
})


-- Yanks
vim.keymap.set({ "n", "x", }, "<Leader>y", [["+y]],  { desc = "Yank to clipboard" })
vim.keymap.set("n",           "<Leader>Y", [["+y$]], { desc = "Yank rest of line to clipboard" })
vim.keymap.set("x",           "<Leader>Y", [["+Y]],  { desc = "Yank lines to clipboard" })
vim.keymap.set("n",           "<Leader>yd", function()
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

local function make_yank_guard()
    local last_yank = { content = vim.fn.getreg('"'), regtype = vim.fn.getregtype('"') }
    return function()
        local event = vim.v.event
        if event.regname == "+" or event.regname == "*" then
            vim.fn.setreg('"', last_yank.content, last_yank.regtype)
        else
            last_yank.content = event.regcontents
            last_yank.regtype = event.regtype
        end
    end
end
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Prevent clipboard yanks from clobbering the unnamed register",
    group = yank_group,
    callback = make_yank_guard(),
})


-- Deletes
vim.keymap.set({ "n", "x", }, "<Leader>d", [["_d]],  { desc = "Don't save deleted text to buffer" })
vim.keymap.set({ "n", "x", }, "<Leader>D", [["_D]],  { desc = "Don't save deleted text to buffer" })
vim.keymap.set({ "n", "x", }, "<Leader>x", [["_x]],  { desc = "Don't save deleted text to buffer" })
vim.keymap.set({ "n", "x", }, "<Leader>c", [["_c]],  { desc = "Don't save deleted text to buffer" })
vim.keymap.set("x",           "<Leader>p", [["_dP]], { desc = "Don't save deleted text to buffer" })


-- Quickfix list
vim.keymap.set("n", "<C-j>", "<Cmd>cnext<CR>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-k>", "<Cmd>cprev<CR>zz", { desc = "Prev quickfix" })
vim.keymap.set("n", "<C-q>", function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end, { desc = "Toggle quickfix list" })


-- Location list
vim.keymap.set("n", "<M-j>", "<Cmd>lnext<CR>zz", { desc = "Next location list" })
vim.keymap.set("n", "<M-k>", "<Cmd>lprev<CR>zz", { desc = "Prev location list" })
vim.keymap.set("n", "<M-q>", function()
    if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
        vim.cmd("lclose")
    else
        local ok = pcall(vim.api.nvim_command, "lopen")
        if not ok then  -- lopen errors with E776 if the window has no location list
            vim.notify("No location list")
        end
    end
end, { desc = "Toggle location list" })


-- Text replace
vim.keymap.set("n", "<Leader>ss", [[:.s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Line text replace" })
vim.keymap.set("n", "<Leader>SS", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Global text replace" })


-- Editor
vim.keymap.set("n", "<Leader>ewl", function()
    vim.wo.wrap = not vim.wo.wrap
    vim.notify("Line wrap: " .. (vim.wo.wrap and "on" or "off"))
end, { desc = "Toggle line wrapping" })

vim.keymap.set("n", "<Leader>e=", function()    -- "mzgg=G'z"
    local view = vim.fn.winsaveview()
    vim.cmd("normal! ==gg=G")                   -- NOTE: == prevents undo/redo from jumping to the top of the file
    vim.fn.winrestview(view)
end, { desc = "Reindent file" })

vim.keymap.set("n", "<Leader>et", function()
    local char = vim.fn.getcharstr()
    local num = tonumber(char)
    if num and num >= 1 and num <= 9 then
        vim.opt_local.tabstop = num
        vim.opt_local.shiftwidth = num
        vim.notify((vim.bo.expandtab and "shiftwidth=" or "tabstop=") .. num)
    end
end, { desc = "Set tabstop" })

-- Editor — UI
vim.keymap.set("n", "<Leader>eur", function()
    vim.wo.nu = true
    vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })

vim.keymap.set("n", "<Leader>eucc", function()
    local on = vim.wo.colorcolumn == ""
    vim.wo.colorcolumn = on and "81,121" or ""
end, { desc = "Toggle colorcolumn" })

vim.keymap.set("n", "<Leader>eug", function()
    local gutter_hidden = {
        number = false,
        relativenumber = false,
        signcolumn = "no",
        foldcolumn = "0",
        statuscolumn = "",
    }
    local saved = vim.w.saved_gutter
    if saved then
        for name, value in pairs(saved) do
            vim.wo[name] = value
        end
        vim.w.saved_gutter = nil
    else
        saved = {}
        for name, hidden in pairs(gutter_hidden) do
            saved[name] = vim.wo[name]
            vim.wo[name] = hidden
        end
        vim.w.saved_gutter = saved
    end
end, { desc = "Toggle gutter" })

local function make_zoom_toggle()
    local zoom_restore = {}
    return function()
        local tab = vim.api.nvim_get_current_tabpage()
        if zoom_restore[tab] then
            vim.cmd(zoom_restore[tab])
            zoom_restore[tab] = nil
        else
            zoom_restore[tab] = vim.fn.winrestcmd()
            vim.cmd.wincmd("_")
            vim.cmd.wincmd("|")
        end
    end
end
vim.keymap.set("n", "<Leader>euz", make_zoom_toggle(), { desc = "Toggle window maximize" })

-- Editor — Stats
vim.keymap.set("n", "<Leader>eswc", function()
    local words = vim.fn.wordcount().words
    vim.notify(("Word count: %d"):format(words))
end, { desc = "Word count" })

