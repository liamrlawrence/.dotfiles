function SetTheme(theme, transparent)
	theme = theme or "nightfox"
	vim.cmd.colorscheme(theme)

	if transparent == true then
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	end


    -- Highlighting rules for comments
    local comments = vim.api.nvim_get_hl(0, { name = 'Comment' })
    vim.api.nvim_set_hl(0, 'Comment', {
        italic = true
    })

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

SetTheme("nightfox", false)

