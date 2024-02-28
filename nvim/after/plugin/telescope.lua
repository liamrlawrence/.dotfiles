require("telescope").setup{
    defaults = { 
        file_ignore_patterns = {
            ".git",
            "venv",
            "node_modules",
        }
    }
}

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {desc = "Find files"})
vim.keymap.set("n", "<C-p>", builtin.git_files, {desc = "Git files"})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, {desc = "Grep string"})

