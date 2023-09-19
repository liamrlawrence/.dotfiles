require("liamrlawrence")

vim.cmd[[
syntax match TodoHighlight /TODO:/
syntax match BugHighlight /BUG:/
highlight TodoHighlight ctermfg=red gui=bold guifg=red
highlight BugHighlight ctermfg=blue gui=bold guifg=blue
]]


