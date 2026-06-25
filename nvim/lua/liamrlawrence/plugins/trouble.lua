return {
    "folke/trouble.nvim",

    config = function()
        local trouble = require("trouble")
        trouble.setup({})

        vim.keymap.set("n", "<M-C-j>", function() trouble.next({ skip_groups = true, jump = true }) end, { desc = "Next Trouble item" })
        vim.keymap.set("n", "<M-C-k>", function() trouble.prev({ skip_groups = true, jump = true }) end, { desc = "Previous Trouble item" })

        vim.keymap.set("n", "<F1>",   function()
            trouble.toggle({ mode = "diagnostics" })
        end, { desc = "Diagnostics (Trouble)" })

        vim.keymap.set("n", "<S-F1>", function()
            trouble.toggle({ mode = "diagnostics", filter = { buf = 0 } })
        end, { desc = "Buffer Diagnostics (Trouble)" })

        vim.keymap.set("n", "<F2>", function()
            vim.cmd.lclose()
            trouble.toggle({ mode = "loclist" })
        end, { desc = "Location List (Trouble)" })

        vim.keymap.set("n", "<S-F2>", function()
            vim.cmd.cclose()
            trouble.toggle({ mode = "qflist" })
        end, { desc = "Quickfix List (Trouble)" })

        vim.keymap.set("n", "<F3>", function()
            trouble.toggle({ mode = "symbols", focus = false, win = { position = "right" } })
        end, { desc = "Symbols (Trouble)" })

        vim.keymap.set("n", "<S-F3>",   function()
            trouble.toggle({ mode = "lsp",focus = false, win = { position = "right" } })
        end, { desc = "LSP Definitions / references / ... (Trouble)" })

    end,

    keys = { "<F1>", "<S-F1>", "<F2>", "<S-F2>", "<F3>", "<S-F3>", },
}

