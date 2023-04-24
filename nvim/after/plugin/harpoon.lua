local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>A", mark.rm_file)

vim.keymap.set("n", "<C-[>", ui.nav_prev)
vim.keymap.set("n", "<C-]>", ui.nav_next)

