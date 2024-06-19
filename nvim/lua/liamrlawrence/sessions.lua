local augroup = vim.api.nvim_create_augroup
local session_group = augroup("LL.session-group", { clear = true })


vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Restore vim session",
    group = session_group,
    nested = true,
    callback = function()
        if (vim.fn.isdirectory(".git") == 1) and (vim.fn.argc() == 1 and vim.fn.argv(0) == ".") then
            local session_file = ".git/session.vim"

            if vim.fn.filereadable(session_file) == 1 then
                vim.cmd("source " .. session_file)
            end

            vim.api.nvim_create_autocmd({ "BufEnter", "VimLeavePre" }, {
                desc = "Save vim session",
                group = session_group,
                callback = function()
                    vim.cmd("mksession! " .. session_file)
                end,
            })
        end
    end,
})

