local file_patterns = {
    "*.env*",
    "*.yaml",
    "*.yml",
}

return {
    "laytan/cloak.nvim",
    event = vim.tbl_map(function(p) return "BufReadPre " .. p end, file_patterns),

    config = function()
        require("cloak").setup({
            cloak_character = "*",
            cloak_length = 8,
            patterns = {
                {
                    file_pattern = file_patterns,
                    cloak_pattern = {
                        "=.+",              -- bash
                        ":.+", "-.+",       -- yaml
                    },
                },
            },
            cloak_on_leave = true,          -- ;)
        })

        vim.keymap.set("n", "<Leader>ec", vim.cmd.CloakPreviewLine, { desc = "Preview cloaked line" })
        vim.keymap.set("n", "<Leader>eC", vim.cmd.CloakToggle,      { desc = "Toggle Cloak" })
    end,
}

