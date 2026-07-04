return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",

    config = function()
        require("gitsigns").setup({
            on_attach = function(bufnr)
                local ft = vim.bo[bufnr].filetype
                if ft == "org" or ft == "orgagenda" then
                    return false
                end
            end,
        })

        vim.keymap.set("n", "<leader>gg", "<cmd>Gitsigns toggle_signs<cr>", { desc = "Toggle Git signs" })
    end,
}

