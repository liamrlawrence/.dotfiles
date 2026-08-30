return {
    "hat0uma/csvview.nvim",

    config = function()
        local csvview_group = vim.api.nvim_create_augroup("LL.plugins_csvview-group", { clear = true })
        local csvview = require("csvview")
        local view_opts = {
            parser = { delimiter = "," },
            view = { display_mode = "border", header_lnum = 1 },
        }

        csvview.setup()

        vim.api.nvim_create_autocmd("FileType", {
            desc = "Register csv buffer keymaps",
            group = csvview_group,
            pattern = "csv",
            callback = function(args)
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(args.buf) and not csvview.is_enabled(args.buf) then
                        csvview.enable(args.buf, view_opts)
                    end
                end)

                vim.keymap.set("n", "<Leader>ep", function()
                    csvview.toggle(args.buf, view_opts)
                end, { buffer = args.buf, desc = "Toggle preview (CSV)" })
            end,
        })
    end,
}

