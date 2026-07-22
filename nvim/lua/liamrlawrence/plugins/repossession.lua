return {
    "liamrlawrence/repossession.nvim",

    config = function()
        require("repossession").setup({
            ignore_filetypes = {
                "trouble",
                "neo-tree",
                "dap-view",
                "dap-view-term",
            },
        })

        vim.keymap.set("n", "<Leader>rp", "<Cmd>Repossession<CR>",      { desc = "Session manager" })
        vim.keymap.set("n", "<Leader>rl", "<Cmd>Repossession last<CR>", { desc = "Toggle to last session" })
    end,
}

