return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        require("todo-comments").setup{
            colors = {
                error   = { "DiagnosticError", "ErrorMsg",  "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info    = { "DiagnosticInfo",               "#2563EB" },
                hint    = { "DiagnosticHint",               "#10B981" },
                test    = { "Identifier",                   "#FF00FF" },
                perf    = { "Identifier",                   "#7C3AED" },
                default = { "Identifier",                   "#7C3AED" },
                doc     = {                                 "#0096FF" },
                done    = {                                 "#00A36C" },
            },
            keywords = {
                -- FIX: Fixme, Fixit, Bug, Bugfix, Issue
                FIX = {
                    icon = " ",
                    color = "error",
                    alt = { "FIXME", "FIXIT", "BUG", "BUGFIX", "ISSUE" },
                },
                -- TODO:
                TODO = {
                    icon = " ",
                    color = "info",
                },
                -- NOTE: Info
                NOTE = {
                    icon = " ",
                    color = "hint",
                    alt = { "INFO" },
                },
                -- HACK:
                HACK = {
                    icon = " ",
                    color = "warning",
                },
                -- WARN: Warning, Caution
                WARN = {
                    icon = " ",
                    color = "warning",
                    alt = { "WARNING", "CAUTION" },
                },
                -- PERF: Performance, Optim, Optimize
                PERF = {
                    icon = "󰅒 ",
                    color = "perf",
                    alt = { "PERFORMANCE", "OPTIM", "OPTIMIZE" },
                },
                -- TEST: Testing, Passed, Failed
                TEST = {
                    icon = "󱎫 ",
                    color = "test",
                    alt = { "TESTING", "PASSED", "FAILED" },
                },
                -- DOC: Documentation
                DOC = {
                    icon = "󰈙 ",
                    color = "doc",
                    alt = { "DOCUMENTATION" },
                },
                -- DONE: Finished, Completed
                DONE = {
                    icon = " ",
                    color = "done",
                    alt = { "FINISHED", "COMPLETED"  },
                },
            }
        }
    end
}

