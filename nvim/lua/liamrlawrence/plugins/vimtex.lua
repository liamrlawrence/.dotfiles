return {
    "lervag/vimtex",
    ft = { "tex" },

    init = function()
        local vimtex_group = vim.api.nvim_create_augroup("LL.plugins_vimtex-group", { clear = true })
        vim.g.vimtex_view_method = "general"
        vim.g.vimtex_view_general_viewer = "tdf-tab"
        vim.g.vimtex_view_general_options = "@pdf"

        vim.api.nvim_create_autocmd("FileType", {
            desc = "Register tex buffer keymaps",
            group = vimtex_group,
            pattern = "tex",
            callback = function(args)
                vim.keymap.set("n", "<leader>ep", "<cmd>VimtexCompile<cr>", { buffer = args.buf, desc = "Toggle preview (LaTeX)" })
            end,
        })
    end,
}

