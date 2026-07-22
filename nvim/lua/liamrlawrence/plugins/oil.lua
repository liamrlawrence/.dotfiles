return {
    "stevearc/oil.nvim",
    event = "VeryLazy",

    config = function()
        require("oil").setup()

        vim.keymap.set("n", "<Leader>pv", vim.cmd.Oil, { desc = "Explorer" })
    end,
}

