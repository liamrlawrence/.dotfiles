vim.api.nvim_set_hl(0, 'GoldHighlight',         {ctermfg='Yellow',      bold=true, fg='#ffbf00'})
vim.api.nvim_set_hl(0, 'CyanHighlight',         {ctermfg='Cyan',        bold=true, fg='#00ffff'})
vim.api.nvim_set_hl(0, 'BlueHighlight',         {ctermfg='LightBlue',   bold=true, fg='#0096ff'})
vim.api.nvim_set_hl(0, 'DarkOrangeHighlight',   {ctermfg='LightRed',    bold=true, fg='#cc5000'})

vim.fn.matchadd('GoldHighlight',        'TODO:')
vim.fn.matchadd('CyanHighlight',        'BUG:')
vim.fn.matchadd('CyanHighlight',        'BUGFIX:')
vim.fn.matchadd('BlueHighlight',        'NOTE:')
vim.fn.matchadd('BlueHighlight',        'DOC:')
vim.fn.matchadd('DarkOrangeHighlight',  'WARN:')

