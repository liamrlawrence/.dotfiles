return {
    "tpope/vim-fugitive",

    config = function()
        local fugitive_group = vim.api.nvim_create_augroup("LL.plugins_fugitive-group", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            desc = "Register fugitive buffer keymaps",
            group = fugitive_group,
            pattern = "fugitive",
            callback = function(args)
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, { buffer = args.buf, desc = "Git push" })

                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ "pull",  "--rebase" })
                end, { buffer = args.buf, desc = "Git pull" })  -- rebase always

                vim.keymap.set("n", "<leader>t", ":Git push -u origin ",
                    { buffer = args.buf, desc = "Git push new branch & set upstream tracking" })
            end,
        })

        vim.keymap.set("n", "<leader>gs", function()
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].filetype == "fugitive" then
                    vim.api.nvim_win_close(win, false)
                    return
                end
            end
            vim.cmd.Git()
        end, { desc = "Git Status (toggle)" })

        vim.keymap.set("n", "<leader>gD", function()
            if vim.wo.diff then return end

            local unmerged = vim.fn.systemlist({ "git", "ls-files", "-u", "--", vim.fn.expand("%:p") })
            if vim.v.shell_error ~= 0 or #unmerged == 0 then
                vim.notify("No merge conflict for this file", vim.log.levels.INFO)
                return
            end

            -- HACK: linematch subdivides conflict hunks so diffget only grabs
            -- one sub-hunk at a time; disable it globally for whole-hunk diffget
            -- (see: neovim/issues/22696)
            vim.opt.diffopt:remove("linematch:40")
            vim.api.nvim_create_autocmd("BufWinLeave", {
                desc = "Restore linematch option after leaving diffview",
                group = fugitive_group,
                pattern = "fugitive://*",
                once = true,
                callback = function()
                    vim.opt.diffopt:append("linematch:40")
                end,
            })

            vim.cmd("Gvdiffsplit!")
        end, { desc = "Git diff (3-way merge)" })
        vim.keymap.set("n", "gh", "<cmd>diffget //2<cr>", { desc = "Diffget left" })
        vim.keymap.set("n", "gl", "<cmd>diffget //3<cr>", { desc = "Diffget right" })
    end,
}

