return {
    "liamrlawrence/crayons.nvim",
    dependencies = {
        "liamrlawrence/cabinet.nvim",
        "folke/styler.nvim",
        --
        "rebelot/kanagawa.nvim",
        "folke/tokyonight.nvim",
        "EdenEast/nightfox.nvim",
        "motaz-shokry/gruvbox.nvim",
        --
        "Mofiqul/vscode.nvim",
        "chaserensberger/christmas.nvim",
    },

    config = function()
        -- Theme setup
        require("kanagawa").setup({
            overrides = function(colors)
                local theme = colors.theme
                return {
                    EndOfBuffer = { fg = theme.ui.nontext },
                }
            end,
        })

        require("tokyonight").setup({
            on_highlights = function(highlights, colors)
                highlights.EndOfBuffer = { fg = colors.dark3 }
            end,
        })


        -- Plugin setup
        require("crayons").setup({
            themes = {
                {   -- 1
                    name = "kanagawa",
                    variants = {
                        standard = "kanagawa-wave",
                        dark     = "kanagawa-dragon",
                        darkest  = "kanagawa-dragon",
                        light    = "kanagawa-lotus",
                    }
                },
                {   -- 2
                    name = "tokyonight",
                    variants = {
                        standard = "tokyonight-storm",
                        dark     = "tokyonight-moon",
                        darkest  = "tokyonight-night",
                        light    = "tokyonight-day",
                    }
                },
                {   -- 3
                    name = "nightfox1",
                    variants = {
                        standard = "nightfox",
                        dark     = "terafox",
                        darkest  = "carbonfox",
                        light    = "dayfox",
                    }
                },
                {   -- 4
                    name = "nightfox2",
                    variants = {
                        standard = "nordfox",
                        dark     = "duskfox",
                        darkest  = "carbonfox",
                        light    = "dawnfox",
                    }
                },
                {}, -- 5
                {}, -- 6
                {}, -- 7
                {}, -- 8
                {}, -- 9
                {   -- 10
                    name = "gruvbox",
                    variants = {
                        standard = "gruvbox-soft",
                        dark     = "gruvbox-medium",
                        darkest  = "gruvbox-hard",
                        light    = "gruvbox-light",
                    }
                },
            },

            special_themes = {
                {
                    colorscheme = "vscode",
                    background = "dark",
                    transparent = false,
                    keybinding = "<leader>ttv",
                },
                {
                    colorscheme = "christmas",
                    background = "dark",
                    transparent = false,
                    keybinding = "<leader>thc",
                },
            },

            filetype_themes = {
                -- Git
                {
                    filetype = "fugitive",
                    colorscheme = "carbonfox",
                    background = "dark",
                },

                -- C/C++
                {
                    filetype = { "c", "cpp" },
                    colorscheme = "kanagawa-wave",
                    background = "dark",
                },
                {
                    pattern = { "*.h", "*.hh", "*.hpp" },
                    colorscheme = "kanagawa-dragon",
                    background = "dark",
                },
            },
        })
    end,
}

