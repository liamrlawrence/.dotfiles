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
        })


        local cloak_group = vim.api.nvim_create_augroup("LL.plugins_cloak-group", { clear = true })
        local cloak_disabled_buffers = {}

        vim.keymap.set("n", "<leader>es", vim.cmd.CloakPreviewLine)
        vim.keymap.set("n", "<leader>eS", function()
            vim.cmd.CloakToggle()
            -- Make sure that Cloak is re-enabled after leaving the file
            local bufnr = vim.api.nvim_get_current_buf()
            if not cloak_disabled_buffers[bufnr] then
                local autocmd_id = vim.api.nvim_create_autocmd("BufWinLeave", {
                    desc = "Re-enable Cloak after leaving a file that was disabled",
                    group = cloak_group,
                    buffer = bufnr,
                    callback = function()
                        vim.cmd.CloakEnable()
                        vim.api.nvim_del_autocmd(cloak_disabled_buffers[bufnr])
                        cloak_disabled_buffers[bufnr] = nil
                    end,
                })
                cloak_disabled_buffers[bufnr] = autocmd_id
            end
        end, { desc = "Toggle cloaking secrets" })
    end
}

