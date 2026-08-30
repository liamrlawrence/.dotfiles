return {
    "meanderingprogrammer/render-markdown.nvim",
    ft = { "markdown" },

    config = function()
        local render_markdown_group = vim.api.nvim_create_augroup("LL.plugins_render-markdown-group", { clear = true })
        require("render-markdown").setup()

        vim.api.nvim_create_autocmd("FileType", {
            desc = "Register markdown buffer keymaps",
            group = render_markdown_group,
            pattern = "markdown",
            callback = function(args)
                vim.keymap.set("n", "<Leader>ep", "<Cmd>RenderMarkdown toggle<CR>", { buffer = args.buf, desc = "Toggle preview (Markdown)" })
            end,
        })
    end,
}

