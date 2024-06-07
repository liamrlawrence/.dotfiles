return {
    "laytan/cloak.nvim",

    config = function()
        require("cloak").setup({
            enabled = true,
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
        })

        vim.keymap.set("n", "<leader>ec", vim.cmd.CloakToggle, { desc = "Toggle cloaking" });
    end
}

