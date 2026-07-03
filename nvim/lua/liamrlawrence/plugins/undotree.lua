return {
    "mbbill/undotree",

    config = function()
        local undotree_group = vim.api.nvim_create_augroup("LL.plugins_undotree-group", { clear = true })
        vim.api.nvim_create_autocmd("User", {
            desc = "Clean up undotree UI when leaving a session",
            group = undotree_group,
            pattern = "RepossessionSwitchPre",
            command = "UndotreeHide",
        })

        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })
    end,

    keys = { "<leader>u" },
}

