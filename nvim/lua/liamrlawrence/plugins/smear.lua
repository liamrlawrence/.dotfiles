return {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",

    config = function()
        require("smear_cursor").setup({
            time_interval = 4,
            stiffness = 0.8,
            trailing_stiffness = 0.45,
            damping = 0.85,
            anticipation = 0.1,
        })

        vim.keymap.set("n", "<Leader>es", "<Cmd>SmearCursorToggle<CR>", { desc = "Toggle Smear" })
    end,
}

