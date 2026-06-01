return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",

    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add()                         end, { desc = "Harpoon add file" })
        vim.keymap.set("n", "<M-]>",     function() harpoon:list():next()                        end, { desc = "Harpoon next file" })
        vim.keymap.set("n", "<M-[>",     function() harpoon:list():prev()                        end, { desc = "Harpoon prev file" })
        vim.keymap.set("n", "<C-e>",     function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon toggle menu" })
    end
}

