local augroup = vim.api.nvim_create_augroup
local session_group = augroup("LL.session-group", { clear = true })


vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Initialize vim session",
    group = session_group,
    nested = true,
    callback = function()
        local session_file = nil
        local shada_file = vim.fn.stdpath("data") .. "/sessions/global_data.shada"

        -- Load session if 'vim .' was run in a directory containing a git project
        if (vim.fn.isdirectory(".git") == 1) and (vim.fn.argc() == 1 and vim.fn.argv(0) == ".") then
            session_file = ".git/session.vim"
            shada_file = ".git/data.shada"

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

        -- Load shada
        vim.opt.shadafile = shada_file
        if vim.fn.filereadable(shada_file) == 1 then
            vim.cmd("rshada!")
        end
    end,
})

