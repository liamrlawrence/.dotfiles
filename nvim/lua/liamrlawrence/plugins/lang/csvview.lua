return {
    "hat0uma/csvview.nvim",
    ft = { "csv" },

    config = function()
        local csvview_group = vim.api.nvim_create_augroup("LL.plugins_csvview-group", { clear = true })
        local csvview = require("csvview")
        csvview.setup({
            view = { display_mode = "border", header_lnum = 1 },
        })

        vim.api.nvim_create_autocmd("FileType", {
            desc = "Register csv buffer keymaps",
            group = csvview_group,
            pattern = "csv",
            callback = function(args)
                if not csvview.is_enabled(args.buf) then
                    csvview.enable(args.buf)
                end

                vim.keymap.set("n", "<Leader>ep", "<Cmd>CsvViewToggle<CR>", { buffer = args.buf, desc = "Toggle preview (CSV)" })
            end,
        })
    end,
}

