return __LazyVirtualPlugin({
    "liamrlawrence/wrap-motions.nvim",

    config = function()
        local wrap_motions_modes = { "n", "x", "o" }
        local wrap_motions_maps = {
            -- lhs,  no-wrap,  wrap,  desc
            { "j",  "j",  "gj", "Down (screen line)"    },
            { "k",  "k",  "gk", "Up (screen line)"      },
            { "0",  "0",  "g0", "Start of screen line"  },
            { "$",  "$",  "g$", "End of screen line"    },
            { "gj", "gj", "j",  "Down (logical line)"   },
            { "gk", "gk", "k",  "Up (logical line)"     },
            { "g0", "g0", "0",  "Start of logical line" },
            { "g$", "g$", "$",  "End of logical line"   },
        }

        local enabled = false
        local saved = {}

        local function wrap_aware(nowrap, wrap)
            return function() return vim.wo.wrap and wrap or nowrap end
        end

        local function enable()
            if enabled then return end
            saved = {}
            for _, m in ipairs(wrap_motions_maps) do
                local lhs, nowrap, wrap, desc = unpack(m)
                for _, mode in ipairs(wrap_motions_modes) do
                    local existing = vim.fn.maparg(lhs, mode, false, true)
                    if not vim.tbl_isempty(existing) and existing.buffer == 0 then
                        table.insert(saved, existing)
                    end
                end
                vim.keymap.set(wrap_motions_modes, lhs, wrap_aware(nowrap, wrap),
                    { expr = true, desc = desc })
            end
            enabled = true
        end

        local function disable()
            if not enabled then return end
            for _, m in ipairs(wrap_motions_maps) do
                pcall(vim.keymap.del, wrap_motions_modes, m[1])
            end
            for _, map in ipairs(saved) do
                pcall(vim.fn.mapset, map)
            end
            saved = {}
            enabled = false
        end

        vim.keymap.set("n", "<Leader>ewm", function()
            if enabled then disable() else enable() end
            vim.notify("Wrap motions: " .. (enabled and "on" or "off"))
        end, { desc = "Toggle wrap-aware motions" })
    end,

    keys = { "<Leader>ewm" },
})

