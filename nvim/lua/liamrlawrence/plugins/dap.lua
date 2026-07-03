return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { "igorlfs/nvim-dap-view" },

        config = function()
            local dap = require("dap")
            local dapview = require("dap-view")
            local dap_group = vim.api.nvim_create_augroup("LL.plugins_dap-group", { clear = true })

            -- Autocmds
            vim.api.nvim_create_autocmd("User", {
                desc = "Clean up dap UI when leaving a session",
                group = dap_group,
                pattern = "RepossessionSwitchPre",
                callback = function()
                    pcall(require("dap-view").close)
                    pcall(require("dap").terminate)
                end,
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
            vim.keymap.set("n",          "<S-F11>", dap.continue,          { desc = "DAP: run/start" })
            vim.keymap.set("n",          "<S-F10>", dap.continue,          { desc = "DAP: debug/start" })
            vim.keymap.set("n",          "<F7>",    dap.continue,          { desc = "DAP: resume" })
            vim.keymap.set("n",          "<F8>",    dap.step_into,         { desc = "DAP: step into" })
            vim.keymap.set("n",          "<F9>",    dap.step_over,         { desc = "DAP: step over" })
            vim.keymap.set("n",          "<S-F9>",  dap.step_out,          { desc = "DAP: step out" })
            vim.keymap.set("n",          "<F12>",   dap.toggle_breakpoint, { desc = "DAP: toggle breakpoint" })
            vim.keymap.set({ "n", "v" }, "<S-F12>", dapview.add_expr,      { desc = "DAP: watch expression" })
        end,

        keys = { "<S-F10>", "<S-F11>", "<F12>", "<S-F12>" },
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

