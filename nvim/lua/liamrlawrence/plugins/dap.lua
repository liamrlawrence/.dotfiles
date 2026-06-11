return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { "igorlfs/nvim-dap-view" },

        config = function()
            local dap     = require("dap")
            local dapview = require("dap-view")
            local dap_group = vim.api.nvim_create_augroup("LL.plugins_dap-group", { clear = true })

            -- Autocmds
            local function dap_cleanup()
                if package.loaded["dap-view"] then
                    pcall(require("dap-view").close)
                end
                if package.loaded["dap"] then
                    pcall(require("dap").terminate)
                end
                for _, w in ipairs(vim.api.nvim_list_wins()) do
                    local ft = vim.bo[vim.api.nvim_win_get_buf(w)].filetype
                    if ft == "dap-view" or ft == "dap-view-term" then
                        pcall(vim.api.nvim_win_close, w, true)
                    end
                end
                for _, b in ipairs(vim.api.nvim_list_bufs()) do
                    local ft = vim.bo[b].filetype
                    if ft == "dap-view" or ft == "dap-view-term" then
                        pcall(vim.api.nvim_buf_delete, b, { force = true })
                    end
                end
            end

            vim.api.nvim_create_autocmd("User", {
                desc     = "Close dap UI before session switch",
                group    = dap_group,
                pattern  = "RepossessionSwitchPre",
                callback = dap_cleanup,
            })

            vim.api.nvim_create_autocmd("ExitPre", {
                desc     = "Close dap UI before exit",
                group    = dap_group,
                callback = dap_cleanup,
            })

            -- Config
            dapview.setup()
            dap.listeners.after.event_initialized["dap-view-config"] = function()
                dapview.open()  -- Auto open dap-view with the session
            end

            -- UI
            vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "ErrorMsg" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "ErrorMsg" })
            vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DiagnosticError" })
            vim.fn.sign_define("DapLogPoint",            { text = "◆", texthl = "DiagnosticInfo" })
            vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticOk", linehl = "CursorLine" })

            -- Keymaps
            vim.keymap.set({ "n", "v" }, "<leader>za", dapview.add_expr,  { desc = "DAP: watch expression" })
            vim.keymap.set("n",          "<leader>zl", dap.run_last,      { desc = "DAP: re-run last config" })
            vim.keymap.set("n",          "<leader>zC", dap.run_to_cursor, { desc = "DAP: run to cursor" })
            vim.keymap.set("n",          "<leader>zT", dap_cleanup,       { desc = "DAP: terminate" })
        end,

        keys = {
            { "<leader>zb", function() require("dap").toggle_breakpoint() end, desc = "DAP: toggle breakpoint" },
            { "<leader>zc", function() require("dap").continue()          end, desc = "DAP: continue" },
        },
    },


    -- Python
    {
        "mfussenegger/nvim-dap-python",
        dependencies = { "mfussenegger/nvim-dap" },
        ft = { "python" },

        config = function()
            local venv = os.getenv("VIRTUAL_ENV")
            require("dap-python").setup(venv and (venv .. "/bin/python") or "python3")
        end,
    },
}

