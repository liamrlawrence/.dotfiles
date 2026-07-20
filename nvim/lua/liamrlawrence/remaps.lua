local augroup = vim.api.nvim_create_augroup
local explorer_group  = augroup("LL.remaps_explorer-group",  { clear = true })
local highlight_group = augroup("LL.remaps_highlight-group", { clear = true })
local yank_group      = augroup("LL.remaps_yank-group",      { clear = true })
local editor_group    = augroup("LL.remaps_editor-group",    { clear = true })



-- Disabled
vim.keymap.set("n", "Q", "<nop>", { desc = "<Nop>" })


-- Save
vim.keymap.set("n", "ZA", "<cmd>confirm wqa<cr>", { desc = "Write-Quit-All" })


-- Tabs
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>",           { desc = "New tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew<cr><leader>/f", { desc = "New tab with file picker", remap = true })


-- Explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Explorer" })
vim.api.nvim_create_autocmd("FileType", {
    desc = "Netrw formatting",
    group = explorer_group,
    pattern = "netrw",
    callback = function()
        vim.wo.nu = true
        vim.wo.relativenumber = true
    end,
})


-- Movements
vim.keymap.set("x", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
vim.keymap.set("x", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up" })
vim.keymap.set("n", "J", function() -- "mzJ'z"
    local view = vim.fn.winsaveview()
    vim.cmd(":normal! " .. vim.v.count1 .. "J")
    vim.fn.winrestview(view)
end, { desc = "J does not move cursor" })


-- Jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center on half-page jumps" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center on half-page jumps" })
vim.keymap.set("n", "n", "nzzzv",       { desc = "Center on search jumps"})
vim.keymap.set("n", "N", "Nzzzv",       { desc = "Center on search jumps" })


-- Folds
vim.keymap.set("n", "zR",         "zRzz",  { desc = "Open all folds in file" })
vim.keymap.set("n", "zM",         "zMzz",  { desc = "Close all folds in file" })
vim.keymap.set("n", "<leader>fm", "vimzf", { desc = "Fold function", remap = true })


-- Highlights
vim.keymap.set("n", "<leader>/h", vim.cmd.noh, { desc = "Clear highlights" })   -- NOTE: Can use <C-l> instead
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = highlight_group,
    callback = function()
        vim.hl.on_yank()
    end,
})

local function highlight_visual_mode(key)
    local function get_hl(name)
        return vim.api.nvim_get_hl(0, { name = name, link = false }) --[[@as vim.api.keyset.highlight]]
    end

    local visual_modes = {
        ["v"] = true,
        ["V"] = true,
        [vim.keycode("<C-v>")] = true,
    }

    local original_visual = get_hl("Visual")
    vim.api.nvim_set_hl(0, "Visual", get_hl("IncSearch"))
    vim.cmd("normal! " .. key)

    vim.api.nvim_create_autocmd("ModeChanged", {
        desc = "Restore Visual hl group on leaving Visual mode",
        group = highlight_group,
        callback = function()
            local event = vim.v.event --[[@as {old_mode: string, new_mode: string}]]
            if visual_modes[event.old_mode] and not visual_modes[event.new_mode] then
                vim.api.nvim_set_hl(0, "Visual", original_visual)
                return true -- delete autocmd
            end
        end,
    })
end
vim.keymap.set("n", "<leader>v",     function() highlight_visual_mode("v")                  end, { desc = "Enter visual mode with highlighting" })
vim.keymap.set("n", "<leader>V",     function() highlight_visual_mode("V")                  end, { desc = "Enter Visual mode with highlighting" })
vim.keymap.set("n", "<leader><C-v>", function() highlight_visual_mode(vim.keycode("<C-v>")) end, { desc = "Enter blockwise Visual mode with highlighting" })


-- Yanks
vim.keymap.set("n",           "yY",         [[:%y<cr>]],  { desc = "Yank entire file" })
vim.keymap.set("n",           "<leader>yY", [[:%y+<cr>]], { desc = "Yank entire file to clipboard" })
vim.keymap.set({ "n", "x", }, "<leader>y",  [["+y]],      { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "x", }, "<leader>Y",  [["+yg_]],    { desc = "Yank to clipboard" })
vim.keymap.set("n",           "<leader>yd", function()
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
vim.keymap.set({ "n", "x", }, "<leader>d", [["_d]],  { desc = "Don't save deleted text to buffer" })
vim.keymap.set({ "n", "x", }, "<leader>D", [["_D]],  { desc = "Don't save deleted text to buffer" })
vim.keymap.set({ "n", "x", }, "<leader>x", [["_x]],  { desc = "Don't save deleted text to buffer" })
vim.keymap.set({ "n", "x", }, "<leader>c", [["_c]],  { desc = "Don't save deleted text to buffer" })
vim.keymap.set("x",           "<leader>p", [["_dP]], { desc = "Don't save deleted text to buffer" })


-- Quickfix list
vim.keymap.set("n", "<C-j>", "<cmd>cnext<cr>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<cr>zz", { desc = "Prev quickfix" })
vim.keymap.set("n", "<C-q>", function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            vim.cmd("cclose")
            return
        end
    end
    vim.cmd("copen")
end, { desc = "Toggle quickfix list" })


-- Location list
vim.keymap.set("n", "<M-j>", "<cmd>lnext<cr>zz", { desc = "Next location list" })
vim.keymap.set("n", "<M-k>", "<cmd>lprev<cr>zz", { desc = "Prev location list" })
vim.keymap.set("n", "<M-q>", function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["loclist"] == 1 then
            vim.cmd("lclose")
            return
        end
    end
    if vim.fn.getloclist(0, { nr = 0 }).nr ~= 0 then
        vim.cmd("lopen")
    end
end, { desc = "Toggle location list" })


-- Text replace
vim.keymap.set("n", "<leader>s", [[:.s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Line text replace" })
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Global text replace" })


-- Editor
vim.api.nvim_create_autocmd("OptionSet", {
    desc = "Improved navigation for wrapped lines",
    group = editor_group,
    pattern = "wrap",
    callback = function(args)
        for _, k in ipairs({ "j", "k", "0", "$" }) do
            if vim.v.option_new then
                vim.keymap.set("n", k, function()
                    return vim.v.count == 0 and ("g" .. k) or k
                end, { buffer = args.buf, expr = true, desc = "Improved wrapped line navigation" })
            else
                pcall(vim.keymap.del, "n", k, { buffer = args.buf })
            end
        end
    end,
})

vim.keymap.set("n", "<leader>ew", function()
    vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrapping" })

vim.keymap.set("n", "<leader>er", function()
    vim.wo.nu = true
    vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })

vim.keymap.set("n", "<leader>e=", function()    -- "mzgg=G'z"
    local view = vim.fn.winsaveview()
    vim.cmd("normal! ==gg=G")                   -- NOTE: == prevents undo/redo from jumping to the top of the file
    vim.fn.winrestview(view)
end, { desc = "Reindent file" })

vim.keymap.set("n", "<leader>et", function()
    local char = vim.fn.getcharstr()
    local num = tonumber(char)
    if num and num >= 1 and num <= 9 then
        vim.opt_local.tabstop = num
        vim.opt_local.shiftwidth = num
        vim.notify((vim.bo.expandtab and "shiftwidth=" or "tabstop=") .. num, vim.log.levels.INFO)
    end
end, { desc = "Set tabstop" })

local function make_zoom_toggle()
    local zoom_restore = nil
    return function()
        if zoom_restore then
            vim.cmd(zoom_restore)
            zoom_restore = nil
        else
            zoom_restore = vim.fn.winrestcmd()
            vim.cmd.wincmd("_")
            vim.cmd.wincmd("|")
        end
    end
end
vim.keymap.set("n", "<leader>em", make_zoom_toggle(), { desc = "Toggle window maximize" })

