return {
    "liamrlawrence/nvim-highlight-colors",
    branch = "filetype-options",
    -- dir = "/home/watcher/Dev/neovim/nvim-highlight-colors",

    config = function()
        require("nvim-highlight-colors").setup({
            render = "background",
            filetypes = {
                "html",
                "templ",
                css = {
                    render = "background",
                    enable_tailwind = true,
                },
                "lua",
            },
        })
    end
}

