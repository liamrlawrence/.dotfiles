local augroup = vim.api.nvim_create_augroup
local session_group = augroup("LL.session-group", { clear = true })


vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Initialize vim session",
    group = session_group,
    nested = true,
    callback = function()
        local shada_file = vim.fn.stdpath("data") .. "/sessions/global.shada"
        local session_file = nil

        -- Check if 'nvim .' was run inside of a git project
        local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
        local in_git = vim.v.shell_error == 0
        local opened_dot = vim.fn.argc() == 1 and vim.fn.argv(0) == "."

        if in_git and opened_dot then
            shada_file = git_root .. "/.git/session.shada"
            session_file = git_root .. "/.git/session.vim"
        end

        -- Load shada
        vim.opt.shadafile = shada_file
        if vim.fn.filereadable(shada_file) == 1 then
            vim.cmd("rshada!")
        end

        -- Load session
        if session_file then
            if vim.fn.filereadable(session_file) == 1 then
                vim.cmd("source " .. vim.fn.fnameescape(session_file))
            end

            local save_timer = vim.uv.new_timer()

            vim.api.nvim_create_autocmd({
                "BufAdd",
                "BufDelete",
                "WinNew",
                "WinClosed",
                "TabNew",
                "TabClosed",
                "VimLeavePre",
            }, {
                desc = "Save vim session",
                group = session_group,
                callback = function(ev)
                    -- Timer may be nil if system resources are exhausted
                    if not save_timer then return end

                    -- Ignore floating windows (hover docs, telescope, etc.)
                    if ev.event ~= "VimLeavePre" then
                        local win = vim.api.nvim_get_current_win()
                        if vim.api.nvim_win_get_config(win).relative ~= "" then return end
                    end

                    -- Debounce: wait 500ms before writing
                    save_timer:start(500, 0, vim.schedule_wrap(function()
                        vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
                    end))
                end,
            })
        end
    end,
})

