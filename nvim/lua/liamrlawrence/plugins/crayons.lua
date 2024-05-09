return {
    "liamrlawrence/crayons.nvim",
    event = "VeryLazy",
    dependencies = {
        "liamrlawrence/cabinet.nvim",
        "rebelot/kanagawa.nvim",
        "folke/tokyonight.nvim",
        "Mofiqul/vscode.nvim",
    },

    config = function()
        require("crayons").setup({
            themes = {
                {   -- 1
                    name = "kanagawa",
                    variants = {
                        standard = "kanagawa-wave",
                        light    = "kanagawa-lotus",
                        dark     = "kanagawa-dragon",
                        darkest  = "kanagawa-wave",
                    }
                },
                {   -- 2
                    name = "tokyonight",
                    variants = {
                        standard = "tokyonight-storm",
                        light    = "tokyonight-day",
                        dark     = "tokyonight-night",
                        darkest  = "tokyonight-night",
                    }
                },
            },

            special_themes = {
                {
                    name = "vscode",
                    mode = "dark",
                    transparency = false,
                    keybinding = "<leader>TTv",
                },
            }
        })
    end
}

