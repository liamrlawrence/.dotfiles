return {
    "liamrlawrence/cabinet.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        require("cabinet").setup()
    end
}

