function SetTheme(theme, transparent)
	theme = theme or "nightfox"
	vim.cmd.colorscheme(theme)

	if transparent == true then
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	end
end

SetTheme("nightfox", true)

