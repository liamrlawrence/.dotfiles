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
                -- FIX: FIXME, FIXIT, BUG, BUGFIX, ISSUE
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
                -- NOTE: INFO
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
                -- WARN: WARNING, CAUTION
                WARN = {
                    icon = " ",
                    color = "warning",
                    alt = { "WARNING", "CAUTION" },
                },
                -- PERF: PERFORMANCE, OPTIM, OPTIMIZE
                PERF = {
                    icon = "󰅒 ",
                    color = "perf",
                    alt = { "PERFORMANCE", "OPTIM", "OPTIMIZE" },
                },
                -- TEST: TESTING, PASSED, FAILED
                TEST = {
                    icon = "󱎫 ",
                    color = "test",
                    alt = { "TESTING", "PASSED", "FAILED" },
                },
                -- DOC: DOCUMENTATION
                DOC = {
                    icon = "󰈙 ",
                    color = "doc",
                    alt = { "DOCUMENTATION" },
                },
                -- DONE: FINISHED, COMPLETED
                DONE = {
                    icon = " ",
                    color = "done",
                    alt = { "FINISHED", "COMPLETED"  },
                },
            }
        }
    end
}

