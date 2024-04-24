return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },

    config = function ()
        vim.keymap.set('n', '<leader>pt', '<cmd>Neotree toggle right<CR>')
        vim.keymap.set('n', '<leader>pT', '<cmd>Neotree float reveal toggle<CR>')
    end
}

