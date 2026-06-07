return {
    "tpope/vim-fugitive",

    config = function()
        local fugitive_group = vim.api.nvim_create_augroup("LL.plugins_fugitive-group", { clear = true })
        vim.api.nvim_create_autocmd("BufWinEnter", {
            desc = "Register fugitive buffer keymaps",
            group = fugitive_group,
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()

                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, { buffer = bufnr, desc = "Git push" })

                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ "pull",  "--rebase" })
                end, { buffer = bufnr, desc = "Git pull" })  -- rebase always

                vim.keymap.set("n", "<leader>t", ":Git push -u origin ",
                    { buffer = bufnr, desc = "Git push new branch & set upstream tracking" })
            end,
        })

        vim.keymap.set("n", "<leader>gs", vim.cmd.Git,            { desc = "Git Status" })
        vim.keymap.set("n", "gu",         "<cmd>diffget //2<cr>", { desc = "Diffget left" })
        vim.keymap.set("n", "gh",         "<cmd>diffget //3<cr>", { desc = "Diffget right" })
    end,
}

