return {
    "airblade/vim-gitgutter",

    config = function()
        vim.cmd("GitGutterDisable")     -- Disabled by default
        vim.keymap.set("n", "<leader>gg", vim.cmd.GitGutterToggle);
    end
}

