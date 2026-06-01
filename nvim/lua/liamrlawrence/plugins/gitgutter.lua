return {
    "airblade/vim-gitgutter",
    event = "VeryLazy",

    init = function()
        vim.g.gitgutter_enabled = 0     -- Disabled by default
    end,

    config = function()
        vim.keymap.set("n", "<leader>gg", vim.cmd.GitGutterToggle, { desc = "Toggle GitGutter" })
    end
}

