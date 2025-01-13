return {
    "ThePrimeagen/harpoon",

    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>a", mark.add_file,     { desc = "Harpoon add file" })
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu,  { desc = "Harpoon toggle menu" })
        vim.keymap.set("n", "<M-[>", ui.nav_prev,           { desc = "Harpoon prev file" })
        vim.keymap.set("n", "<M-]>", ui.nav_next,           { desc = "Harpoon next file" })
    end
}

