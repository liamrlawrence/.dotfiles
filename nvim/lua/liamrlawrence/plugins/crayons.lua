return {
    "liamrlawrence/crayons.nvim",
    event = "VeryLazy",
    keys = { "<leader>t" },
    dependencies = {
        "liamrlawrence/cabinet.nvim",
        "rebelot/kanagawa.nvim",
        "folke/tokyonight.nvim",
        "projekt0n/github-nvim-theme",
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
                {   -- 3
                    name = "github",
                    variants = {
                        standard = "github_dark",
                        light    = "github_light",
                        dark     = "github_dark_dimmed",
                        darkest  = "github_dark_high_contrast",
                    }
                },
            },

            special_themes = {
                {
                    name = "vscode",
                    mode = "dark",
                    transparency = false,
                    keybinding = "<leader>ttv",
                },
            }
        })
    end
}

