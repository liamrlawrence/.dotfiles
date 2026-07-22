return __LazyVirtualPlugin({
    "liamrlawrence/show-space.nvim",

    config = function()
        local show_space_ns = vim.api.nvim_create_namespace("LL.plugins_show-space-ns")
        local show_space_group = vim.api.nvim_create_augroup("LL.plugins_show-space-group", { clear = true })

        local function set_lead()
            if not vim.b.blank_line then
                vim.opt_local.listchars = vim.opt_global.listchars:get()
                return
            end
            local sw = vim.bo.shiftwidth
            if sw == 0 then sw = vim.bo.tabstop end
            local lcs = vim.opt_global.listchars:get()
            lcs.leadmultispace = "·" .. string.rep(" ", sw - 1)
            vim.opt_local.listchars = lcs
        end

        local function mark_blanks(buf, enabled)
            vim.api.nvim_buf_clear_namespace(buf, show_space_ns, 0, -1)
            if not enabled then return end
            for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
                if line == "" then
                    vim.api.nvim_buf_set_extmark(buf, show_space_ns, i - 1, 0, {
                        virt_text = { { "~", "NonText" } },
                        virt_text_pos = "overlay",
                    })
                end
            end
        end

        vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
            desc = "Redraw blank-line tildes when entering or editing a buffer",
            group = show_space_group,
            callback = function(args)
                local enabled = vim.b[args.buf].blank_line == true
                mark_blanks(args.buf, enabled)
            end,
        })

        vim.api.nvim_create_autocmd("BufWinEnter", {
            desc = "Sync window list option to the buffer's blank_line flag",
            group = show_space_group,
            callback = function(args)
                local win = vim.api.nvim_get_current_win()
                if vim.api.nvim_win_get_buf(win) ~= args.buf then return end
                vim.wo[win].list = vim.b[args.buf].blank_line == true
                vim.api.nvim_win_call(win, set_lead)
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            desc = "Clean up show-space when leaving a session",
            group = show_space_group,
            pattern = "RepossessionSwitchPre",
            callback = function()
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    vim.wo[win].list = false
                end
            end,
        })

        vim.keymap.set("n", "<Leader>ed", function()
            local buf = vim.api.nvim_get_current_buf()
            local enabled = not (vim.b[buf].blank_line == true)
            vim.b[buf].blank_line = enabled
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == buf then
                    vim.wo[win].list = enabled
                end
            end
            set_lead()
            mark_blanks(buf, enabled)
        end, { desc = "Toggle blank-line tildes + list" })
    end,

    keys = { "<Leader>ed" },
})

