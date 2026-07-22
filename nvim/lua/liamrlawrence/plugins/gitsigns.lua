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

        vim.keymap.set("n", "<Leader>gg", "<Cmd>Gitsigns toggle_signs<CR>", { desc = "Toggle Git signs" })
    end,
}

