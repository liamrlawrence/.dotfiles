return {
    "liamrlawrence/repossession.nvim",

    config = function()
        require("repossession").setup({
            tidy_sessions = true,
        })

        vim.keymap.set("n", "<leader>rp", "<cmd>Repossession<cr>",      { desc = "Session manager" })
        vim.keymap.set("n", "<leader>rl", "<cmd>Repossession last<cr>", { desc = "Toggle to last session" })
    end,
}

