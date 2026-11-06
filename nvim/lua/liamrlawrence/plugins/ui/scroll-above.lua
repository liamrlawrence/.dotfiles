return __LazyVirtualPlugin({
    "liamrlawrence/scroll-above.nvim",

    config = function()
        local function make_scroll_above_padder()
            local scroll_above_group = vim.api.nvim_create_augroup("LL.plugins_scroll-above-group", { clear = true })
            local scroll_above_ns = vim.api.nvim_create_namespace("LL.editor_scroll-above-ns")
            local watching = {}

            local function pad_above(n, buf)
                local eob = vim.opt_local.fillchars:get().eob or "~"
                local lines = {}
                for _ = 1, n do
                    lines[#lines + 1] = { { eob, "EndOfBuffer" } }
                end
                vim.api.nvim_buf_set_extmark(buf, scroll_above_ns, 0, 0, {
                    id = 1,
                    virt_lines = lines,
                    virt_lines_above = true,
                    virt_lines_leftcol = true,
                    right_gravity = false,
                })
            end

            local function pad_above_count(buf)
                local m = vim.api.nvim_buf_get_extmarks(buf, scroll_above_ns, 0, -1, { details = true })
                return #m == 0 and 0 or #m[1][4].virt_lines
            end

            local function watch_padding(buf)
                if watching[buf] then return end
                watching[buf] = true

                local scroll_id, leave_id, diff_id

                local function cleanup()
                    if vim.api.nvim_buf_is_valid(buf) then
                        vim.api.nvim_buf_clear_namespace(buf, scroll_above_ns, 0, -1)
                    end
                    pcall(vim.api.nvim_del_autocmd, scroll_id)
                    pcall(vim.api.nvim_del_autocmd, leave_id)
                    pcall(vim.api.nvim_del_autocmd, diff_id)
                    watching[buf] = nil
                end

                scroll_id = vim.api.nvim_create_autocmd("WinScrolled", {
                    desc = "Clean up scroll-above padding when the buffer's last window scrolls away",
                    group = scroll_above_group,
                    callback = function()
                        if not vim.api.nvim_buf_is_valid(buf) then
                            cleanup()
                            return
                        end
                        for _, bufwin in ipairs(vim.fn.win_findbuf(buf)) do
                            local view = vim.api.nvim_win_call(bufwin, vim.fn.winsaveview)
                            if view.topfill > 0 then return end
                        end
                        cleanup()
                    end,
                })

                leave_id = vim.api.nvim_create_autocmd("BufWinLeave", {
                    desc = "Clean up scroll-above padding when the buffer leaves its last window",
                    group = scroll_above_group,
                    buffer = buf,
                    callback = cleanup,
                })

                diff_id = vim.api.nvim_create_autocmd("OptionSet", {
                    desc = "Clean up scroll-above padding when the buffer enters diff mode",
                    group = scroll_above_group,
                    pattern = "diff",
                    callback = function()
                        if vim.v.option_new and vim.api.nvim_get_current_buf() == buf then
                            cleanup()
                        end
                    end,
                })
            end

            return function()
                if not vim.wo.diff then
                    local buf = vim.api.nvim_get_current_buf()
                    local view = vim.fn.winsaveview()
                    local padding = pad_above_count(buf)
                    local overscroll = vim.v.count1 - (view.topline - 1) + view.topfill
                    local max_padding = vim.api.nvim_win_get_height(0) - 1
                    overscroll = math.min(overscroll, max_padding)
                    if overscroll > padding then
                        watch_padding(buf)
                        pad_above(overscroll, buf)
                    end
                end
                vim.cmd("normal! " .. vim.v.count1 .. vim.keycode("<C-y>"))
            end
        end
        vim.keymap.set("n", "<C-y>", make_scroll_above_padder(), { desc = "Scroll above the first line" })
    end,

    keys = { "<C-y>" },
})

