return {
    "sphamba/smear-cursor.nvim",

    config = function()
        require("smear_cursor").setup({
            time_interval = 7,
            stiffness = 0.8,
            trailing_stiffness = 0.5,
            distance_stop_animation = 0.5,
        })
    end
}

