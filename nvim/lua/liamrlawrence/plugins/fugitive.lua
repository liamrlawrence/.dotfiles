return {
    "tpope/vim-fugitive",

    config = function()
        vim.api.nvim_create_autocmd("BufWinEnter", {
            group = vim.api.nvim_create_augroup("fugitive-group", {}),
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, opts)

                -- Rebase always
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ "pull",  "--rebase" })
                end, opts)

                -- NOTE: Allows me to easily set the branch I am pushing and any tracking needed
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
            end,
        })


        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git Status" })
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    end
}

