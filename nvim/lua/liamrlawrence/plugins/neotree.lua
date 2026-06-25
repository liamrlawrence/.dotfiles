return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },

    config = function ()
        require("neo-tree").setup({
            auto_clean_after_session_restore = true,
            filesystem = {
                hijack_netrw_behavior = "disabled",
            }
        })

        vim.keymap.set("n", "<leader>pt", "<cmd>Neotree toggle right<cr>",        { desc = "Neotree toggle right" })
        vim.keymap.set("n", "<leader>pT", "<cmd>Neotree float reveal toggle<cr>", { desc = "Neotree toggle floating" })
    end,

    keys = { "<leader>pt", "<leader>pT" },
}

