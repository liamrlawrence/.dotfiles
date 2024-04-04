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

-- Case-sensitive grep
vim.keymap.set("n", "<leader>ps", function()
    vim.ui.input({prompt = "Grep > "}, function(input)
        if not input or input == "" then
            print("Grep canceled")
            return
        end
        builtin.grep_string({search = input, ignore_case = false})
    end)
end, {desc = "Grep string (case-sensitive)"})

-- Case-insensitive grep
vim.keymap.set("n", "<leader>pS", function()
    vim.ui.input({prompt = "Grep (ignore case) > "}, function(input)
        if not input or input == "" then
            print("Grep canceled")
            return
        end
        builtin.grep_string({search = input, ignore_case = true})
    end)
end, {desc = "Grep string (ignore case)"})

