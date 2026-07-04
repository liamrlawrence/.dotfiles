return {
    "meanderingprogrammer/render-markdown.nvim",
    ft = { "markdown" },

    config = function()
        require("render-markdown").setup({})
        local render_markdown_group = vim.api.nvim_create_augroup("LL.plugins_render-markdown-group", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            desc = "Register markdown buffer keymaps",
            group = render_markdown_group,
            pattern = "markdown",
            callback = function(args)
                vim.keymap.set("n", "<leader>ep", "<cmd>RenderMarkdown toggle<cr>", { buffer = args.buf, desc = "Toggle preview (Markdown)" })
            end,
        })
    end,
}

