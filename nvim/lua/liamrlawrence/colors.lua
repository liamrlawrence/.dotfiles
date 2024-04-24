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

-- Set custom highlighting rules
function SetHighlights()
    -- Highlight current parameter when looking at a Signature
    local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
    vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', {
        fg = marked.fg,
        bg = marked.bg,
        ctermfg = marked.ctermfg,
        ctermbg = marked.ctermbg,
        bold = true
    })
end

-- Set a theme, and then apply highlight rules
function SetTheme(theme, themeMode, transparent)
    theme = theme or Themes[1]["default"]
    themeMode = themeMode or "dark"
    if themeMode ~= "light" and themeMode ~= "dark" then
        error("Invalid theme mode. Expected 'light' or 'dark'.")
    end
    vim.o.background = themeMode
    vim.cmd.colorscheme(theme)

    -- Apply highlights after setting the theme
    if transparent == true then
        vim.api.nvim_set_hl(0, "LineNr",            { bg = "none" })
        vim.api.nvim_set_hl(0, "SignColumn",        { bg = "none" })
        vim.api.nvim_set_hl(0, "Normal",            { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat",       { bg = "none" })
        vim.api.nvim_set_hl(0, "GitGutterAdd",      { bg = "none", fg = "#009900" })
        vim.api.nvim_set_hl(0, "GitGutterChange",   { bg = "none", fg = "#bbbb00" })
        vim.api.nvim_set_hl(0, "GitGutterDelete",   { bg = "none", fg = "#ff2222" })
    end
    SetHighlights()
end

-- Apply the default theme
SetTheme()

