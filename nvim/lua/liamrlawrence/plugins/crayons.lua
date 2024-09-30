return {
    "liamrlawrence/crayons.nvim",
    -- event = "VeryLazy",
    -- ft = { "org" },
    dependencies = {
        "liamrlawrence/cabinet.nvim",
        "rebelot/kanagawa.nvim",
        "folke/tokyonight.nvim",
        "EdenEast/nightfox.nvim",
        "ribru17/bamboo.nvim",
        "Mofiqul/vscode.nvim",
    },

    config = function()
        require('bamboo').load()
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
                    name = "nightfox1",
                    variants = {
                        standard = "nightfox",
                        light    = "dayfox",
                        dark     = "carbonfox",
                        darkest  = "terafox",
                    }
                },
                {   -- 4
                    name = "nightfox2",
                    variants = {
                        standard = "duskfox",
                        light    = "dawnfox",
                        dark     = "terafox",
                        darkest  = "carbonfox",
                    }
                },
                {}, -- 5
                {}, -- 6
                {}, -- 7
                {}, -- 8
                {}, -- 9
                {   -- 10
                    name = "bamboo",
                    variants = {
                        standard = "bamboo-vulgaris",
                        light    = "bamboo-light",
                        dark     = "bamboo-multiplex",
                        darkest  = "bamboo-multiplex",
                    }
                },
            },

            special_themes = {
                {
                    colorscheme = "vscode",
                    background = "dark",
                    transparency = false,
                    keybinding = "<leader>ttv",
                },
            },

            filetype_themes = {
                {
                    colorscheme = "tokyonight-night",
                    background = "dark",
                    transparency = false,
                    pattern = "*.org",
                },
                {
                    colorscheme = "tokyonight-night",
                    background = "dark",
                    transparency = false,
                    pattern = "fugitive://*",
                },
            },
        })
    end
}

