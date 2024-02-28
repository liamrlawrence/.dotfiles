-- Default  | Standard theme
-- Light    | Light theme
-- Dark     | Dark theme
-- Darkest  | Dark theme + dark background
local Themes = {
    {
        default = "kanagawa-wave",
        light   = "kanagawa-lotus",
        dark    = "kanagawa-dragon",
        darkest = "kanagawa-wave",
    },
    {
        default = "rose-pine-moon",
        light   = "rose-pine-dawn",
        dark    = "rose-pine-main",
        darkest = "rose-pine-main",
    }
}



function SetHighlights()
    -- Color groups
    vim.api.nvim_set_hl(0, 'GoldHighlight',         {ctermfg='Yellow',      bold=true, fg='#ffbf00', bg='#443000'})
    vim.api.nvim_set_hl(0, 'CyanHighlight',         {ctermfg='Cyan',        bold=true, fg='#00ffff', bg='#002222'})
    vim.api.nvim_set_hl(0, 'BlueHighlight',         {ctermfg='LightBlue',   bold=true, fg='#0096ff', bg='#002222'})
    vim.api.nvim_set_hl(0, 'DarkOrangeHighlight',   {ctermfg='LightRed',    bold=true, fg='#cc5000', bg='#221111'})
    vim.api.nvim_set_hl(0, 'RedHighlight',          {ctermfg='LightRed',    bold=true, fg='#dc1423', bg='#221111'})

    -- Highlight keywords
    vim.fn.matchadd('GoldHighlight',        'TODO:')
    vim.fn.matchadd('DarkOrangeHighlight',  'WARNING:')
    vim.fn.matchadd('RedHighlight',         'ERROR:')
    vim.fn.matchadd('RedHighlight',         'BUG:')
    vim.fn.matchadd('CyanHighlight',        'BUGFIX:')
    vim.fn.matchadd('BlueHighlight',        'NOTE:')
    vim.fn.matchadd('BlueHighlight',        'DOC:')

    -- Highlight current parmeter when looking at a Signature
    local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
    vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', {
        fg = marked.fg,
        bg = marked.bg,
        ctermfg = marked.ctermfg,
        ctermbg = marked.ctermbg,
        bold = true 
    })
end



function SetTheme(theme, transparent)
    vim.cmd.colorscheme(theme or Themes[1]["default"])

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




vim.keymap.set("n", "<leader>TT1", string.format(':lua SetTheme("%s")<CR>', Themes[1]["default"]))
vim.keymap.set("n", "<leader>TL1", string.format(':lua SetTheme("%s")<CR>', Themes[1]["light"]))
vim.keymap.set("n", "<leader>TD1", string.format(':lua SetTheme("%s")<CR>', Themes[1]["dark"]))
vim.keymap.set("n", "<leader>Td1", string.format(':lua SetTheme("%s", true)<CR>', Themes[1]["darkest"]))

vim.keymap.set("n", "<leader>TT2", string.format(':lua SetTheme("%s")<CR>', Themes[2]["default"]))
vim.keymap.set("n", "<leader>TL2", string.format(':lua SetTheme("%s")<CR>', Themes[2]["light"]))
vim.keymap.set("n", "<leader>TD2", string.format(':lua SetTheme("%s")<CR>', Themes[2]["dark"]))
vim.keymap.set("n", "<leader>Td2", string.format(':lua SetTheme("%s", true)<CR>', Themes[2]["darkest"]))




-- Apply the default theme
SetTheme()

