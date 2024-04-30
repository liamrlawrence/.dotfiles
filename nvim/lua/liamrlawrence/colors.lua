-- Theme selection
--------------------------------------------
-- Default  | Standard theme
-- Light    | Light theme
-- Dark     | Dark theme
-- Darkest  | Dark theme + dark background
--------------------------------------------
local Themes = {
    {
        default = "kanagawa-wave",
        light   = "kanagawa-lotus",
        dark    = "kanagawa-dragon",
        darkest = "kanagawa-wave",
    },
    {
        default = "catppuccin-macchiato",
        light   = "catppuccin-latte",
        dark    = "catppuccin-mocha",
        darkest = "catppuccin-mocha",
    },
    {
        default = "rose-pine-moon",
        light   = "rose-pine-dawn",
        dark    = "rose-pine-main",
        darkest = "rose-pine-main",
    },
    {
        default = "tokyonight-storm",
        light   = "tokyonight-day",
        dark    = "tokyonight-night",
        darkest = "tokyonight-night",
    },
    {
        default = "solarized",
        light   = "solarized",
        dark    = "solarized",
        darkest = "solarized",
    },
}

for index = 1, #Themes do
    vim.keymap.set("n", "<leader>TT" .. index, string.format(':lua SetTheme("%s", "dark")<CR>', Themes[index]["default"]))
    vim.keymap.set("n", "<leader>TL" .. index, string.format(':lua SetTheme("%s", "light")<CR>', Themes[index]["light"]))
    vim.keymap.set("n", "<leader>TD" .. index, string.format(':lua SetTheme("%s", "dark")<CR>', Themes[index]["dark"]))
    vim.keymap.set("n", "<leader>Td" .. index, string.format(':lua SetTheme("%s", "dark", true)<CR>', Themes[index]["darkest"]))
end

-- Special theme for code reviews with coworkers
vim.keymap.set("n", "<leader>TTv", string.format(':lua SetTheme("vscode")<CR>'))



function SetHighlights(transparency)
    if transparency == true then
        vim.api.nvim_set_hl(0, "LineNr",            { bg = "none" })
        vim.api.nvim_set_hl(0, "SignColumn",        { bg = "none" })
        vim.api.nvim_set_hl(0, "Normal",            { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat",       { bg = "none" })
        vim.api.nvim_set_hl(0, "GitGutterAdd",      { bg = "none", fg = "#009900" })
        vim.api.nvim_set_hl(0, "GitGutterChange",   { bg = "none", fg = "#bbbb00" })
        vim.api.nvim_set_hl(0, "GitGutterDelete",   { bg = "none", fg = "#ff2222" })
    end

    -- Highlight current parameter when looking at a Signature
    local marked = vim.api.nvim_get_hl(0, { name = "PMenu" })
    vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
        fg = marked.fg,
        bg = marked.bg,
        ctermfg = marked.ctermfg,
        ctermbg = marked.ctermbg,
        bold = true
    })
end


function SetTheme(theme_name, theme_mode, theme_transparency)
    -- Load configuration
    local config = require("cabinet").config_manager
    if not theme_name then
        local loaded_config = config.load("theme_config")
        if loaded_config then
            theme_name = loaded_config.theme_name
            theme_mode = loaded_config.theme_mode
            theme_transparency = loaded_config.theme_transparency
        else
            -- Fallback if config file doesn't exist
            theme_name = Themes[1]["default"]
            theme_mode = "dark"
            theme_transparency = false
        end
    end

    -- Default params
    if not theme_mode then
        theme_mode = "dark"
    elseif theme_mode ~= "light" and theme_mode ~= "dark" then
        error("Invalid theme mode. Expected 'light' or 'dark'.")
    end
    if not theme_transparency then
        theme_transparency = false
    end

    -- Set theme
    vim.o.background = theme_mode
    vim.cmd.colorscheme(theme_name)

    -- Apply highlights
    SetHighlights(theme_transparency)

    -- Save settings
    local config_data = {
        theme_name = theme_name,
        theme_mode = theme_mode,
        theme_transparency = theme_transparency
    }
    config.save("theme_config", config_data)
end



-- Apply theme on startup
SetTheme()

