return {
    "nvim-mini/mini.surround",
    event = "VeryLazy",

    config = function()
        require("mini.surround").setup({
            mappings = {
                add            = "<Leader>sa",
                delete         = "<Leader>sd",
                find           = "<Leader>sf",
                find_left      = "<Leader>sf",
                highlight      = "<Leader>sh",
                replace        = "<Leader>sr",
                update_n_lines = "<Leader>sn",
            },
        })
    end,
}

