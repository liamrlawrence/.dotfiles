return {
    "liamrlawrence/repossession.nvim",

    config = function()
        require("repossession").setup({
            tidy_sessions = false,
        })

        vim.keymap.set("n", "<leader>rp", "<cmd>Repossession<cr>", { desc = "Session manager" })
    end,
}

