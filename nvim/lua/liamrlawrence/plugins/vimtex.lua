return {
    "lervag/vimtex",
    event = "VeryLazy",
    ft = { "tex" },

    init = function()
        vim.g.vimtex_view_method = "general"
        vim.g.vimtex_view_general_viewer = "tdf-tab"
        vim.g.vimtex_view_general_options = "@pdf"
    end,
}

