return {
    "airblade/vim-gitgutter",

    config = function()
        vim.keymap.set("n", "<leader>gg", vim.cmd.GitGutterToggle);
    end
}

