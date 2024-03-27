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
    vim.ui.input({prompt = "Grep > "}, function(input)
        if not input or input == "" then
            print("Grep canceled")
            return
        end
        builtin.grep_string({search = input})
    end)
end, {desc = "Grep string"})

