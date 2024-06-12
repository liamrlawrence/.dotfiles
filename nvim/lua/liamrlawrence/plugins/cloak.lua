return {
    "laytan/cloak.nvim",

    config = function()
        require("cloak").setup({
            cloak_character = "*",
            cloak_length = 8,
            patterns = {
                {
                    file_pattern = {
                        "*.env*",
                    },
                    cloak_pattern = {
                        "=.+",              -- bash
                        ":.+", "-.+",       -- yaml
                    },
                },
            },
            cloak_on_leave = true,          -- ;)
        })

        vim.keymap.set("n", "<leader>ec", vim.cmd.CloakPreviewLine, { desc = "Preview cloaked line" })
        vim.keymap.set("n", "<leader>eC", vim.cmd.CloakToggle,      { desc = "Toggle Cloak" })
    end
}

