return {
    "tpope/vim-fugitive",

    config = function()
        local fugitive_group = vim.api.nvim_create_augroup("LL.plugins_fugitive-group", { clear = true })
        local blame_ns = vim.api.nvim_create_namespace("LL.plugins_fugitive-blame-ns")

        -- Autocmds
        vim.api.nvim_create_autocmd("FileType", {
            desc = "Fugitive blame highlights",
            group = fugitive_group,
            pattern = "fugitiveblame",
            callback = function(args)
                local blame_buf = args.buf
                local file_win = vim.fn.win_getid(vim.fn.winnr("l"))
                local file_buf = file_win ~= 0 and vim.api.nvim_win_get_buf(file_win) or nil

                vim.api.nvim_clear_autocmds({
                    group = fugitive_group,
                    buffer = blame_buf,
                })

                vim.api.nvim_create_autocmd("CursorMoved", {
                    desc = "Update the highlight when changing lines in the blame buffer",
                    group = fugitive_group,
                    buffer = blame_buf,
                    callback = function()
                        if not file_buf or not vim.api.nvim_buf_is_valid(file_buf) then return end
                        local lnum = vim.api.nvim_win_get_cursor(0)[1]
                        vim.api.nvim_buf_clear_namespace(file_buf, blame_ns, 0, -1)
                        vim.api.nvim_buf_set_extmark(file_buf, blame_ns, lnum - 1, 0, { line_hl_group = "Visual" })
                    end,
                })

                vim.api.nvim_create_autocmd("BufWinLeave", {
                    desc = "Clear the highlight when the blame buffer closes",
                    group = fugitive_group,
                    buffer = blame_buf,
                    callback = function()
                        if file_buf and vim.api.nvim_buf_is_valid(file_buf) then
                            vim.api.nvim_buf_clear_namespace(file_buf, blame_ns, 0, -1)
                        end
                        vim.api.nvim_clear_autocmds({ group = fugitive_group, buffer = blame_buf })
                    end,
                })
            end,
        })

        -- Keymaps
        vim.api.nvim_create_autocmd("FileType", {
            desc = "Register fugitive buffer keymaps",
            group = fugitive_group,
            pattern = "fugitive",
            callback = function(args)
                vim.keymap.set("n", "<Leader>gp", function() vim.cmd.Git("push")                 end, { buffer = args.buf, desc = "Git push" })
                vim.keymap.set("n", "<Leader>gP", function() vim.cmd.Git({ "pull", "--rebase" }) end, { buffer = args.buf, desc = "Git pull" })
                vim.keymap.set("n", "<Leader>gt", ":Git push -u origin ",                             { buffer = args.buf, desc = "Git push new branch & set upstream tracking" })
            end,
        })
        vim.keymap.set("n", "<Leader>gs", vim.cmd.Git, { desc = "Git status" })
        vim.keymap.set("n", "<Leader>gD", function()
            if vim.wo.diff then return end

            local file_buf = vim.api.nvim_get_current_buf()
            local unmerged = vim.fn.systemlist({ "git", "ls-files", "-u", "--", vim.api.nvim_buf_get_name(file_buf) })
            if vim.v.shell_error ~= 0 or #unmerged == 0 then
                vim.notify("No merge conflict for this file", vim.log.levels.INFO)
                return
            end

            -- HACK: linematch subdivides conflict hunks so diffget only grabs
            -- one sub-hunk at a time; disable it globally for whole-hunk diffget
            -- (see: neovim/issues/22696)
            vim.opt.diffopt:remove("linematch:40")
            local ok, err = pcall(vim.api.nvim_command, "Gvdiffsplit!")
            if not ok then
                vim.opt.diffopt:append("linematch:40")
                vim.notify(err, vim.log.levels.ERROR)
                return
            end

            -- Merge-only keymaps, local to the working file
            vim.keymap.set("n", "gh", "<Cmd>diffget //2<CR>", { buffer = file_buf, desc = "Diffget left (ours)" })
            vim.keymap.set("n", "gl", "<Cmd>diffget //3<CR>", { buffer = file_buf, desc = "Diffget right (theirs)" })

            vim.api.nvim_create_autocmd("BufWinLeave", {
                desc = "Tear down 3-way merge: restore linematch, remove diffget maps",
                group = fugitive_group,
                pattern = "fugitive://*",
                once = true,
                callback = function()
                    vim.opt.diffopt:append("linematch:40")
                    if vim.api.nvim_buf_is_valid(file_buf) then
                        pcall(vim.keymap.del, "n", "gh", { buffer = file_buf })
                        pcall(vim.keymap.del, "n", "gl", { buffer = file_buf })
                    end
                end,
            })
        end, { desc = "Git diff (3-way merge)" })
    end,
}

