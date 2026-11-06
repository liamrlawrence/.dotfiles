return __LazyVirtualPlugin({
    "liamrlawrence/highlight-win-sep.nvim",

    config = function()
        local function make_window_separator_highlight_toggle()
            local win_sep_hl_group = vim.api.nvim_create_augroup("LL.plugins_win-sep-hl-group", { clear = true })
            local win_sep_hl_ns = vim.api.nvim_create_namespace("LL.plugins_win-sep-hl-ns")
            local left_drag = vim.keycode("<LeftDrag>")
            local left_release = vim.keycode("<LeftRelease>")
            local saved_sep = nil

            local function disarm() vim.on_key(nil, win_sep_hl_ns) end

            local function restore()
                disarm()
                if saved_sep then vim.api.nvim_set_hl(0, "WinSeparator", saved_sep) end
                saved_sep = nil
            end

            local function arm()
                local dragged = false
                vim.on_key(function(key)
                    -- substring match (not ==) so modified events like <S-LeftDrag> and
                    -- <2-LeftRelease> also match; plain=true stops the raw key bytes from
                    -- being parsed as a Lua pattern
                    if key:find(left_drag, 1, true) then
                        dragged = true
                    elseif dragged and key:find(left_release, 1, true) then
                        vim.schedule(restore)
                    end
                end, win_sep_hl_ns)
            end

            local function apply()
                saved_sep = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = true })
                local c = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = false }).fg or "#FF9E64"
                vim.api.nvim_set_hl(0, "WinSeparator", { fg = c, bg = c })
            end

            vim.api.nvim_create_autocmd("ColorScheme", {
                desc = "Update separator highlight if enabled and colorscheme changes",
                group = win_sep_hl_group,
                callback = function() if saved_sep then apply() end end,
            })

            local function toggle()
                if saved_sep then restore() else apply() end
            end

            local function toggle_until_drag_end()
                if saved_sep then restore() else apply(); arm() end
            end

            return toggle, toggle_until_drag_end
        end

        local sep_toggle, sep_oneshot = make_window_separator_highlight_toggle()
        vim.keymap.set("n", "<Leader>euws", sep_oneshot, { desc = "Highlight window separators until next drag ends" })
        vim.keymap.set("n", "<Leader>euwS", sep_toggle, { desc = "Toggle window separator highlighting" })
    end,

    keys = { "<Leader>euws", "<Leader>euwS" },
})

