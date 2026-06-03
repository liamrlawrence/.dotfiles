return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",

    config = function()
        require("gitsigns").setup()

        vim.keymap.set("n", "<leader>gg", "<cmd>Gitsigns toggle_signs<cr>", { desc = "Toggle Git signs" })
    end,
}

