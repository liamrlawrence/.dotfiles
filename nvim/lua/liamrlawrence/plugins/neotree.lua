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

        vim.keymap.set("n", "<Leader>pt", "<Cmd>Neotree toggle right<CR>",        { desc = "Neotree toggle right" })
        vim.keymap.set("n", "<Leader>pT", "<Cmd>Neotree float reveal toggle<CR>", { desc = "Neotree toggle floating" })
    end,

    keys = { "<Leader>pt", "<Leader>pT" },
}

