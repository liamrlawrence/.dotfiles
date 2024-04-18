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



-- Git file search
vim.keymap.set("n", "<C-p>", builtin.git_files, {desc = "Git files"})

-- File search
vim.keymap.set("n", "<leader>pf", builtin.find_files, {desc = "Find files"})

-- File search, including hidden files
vim.keymap.set("n", "<leader>pF", function()
    builtin.find_files({
        hidden = true,
        no_ignore = true,
    })
end, {desc = "Find files (including hidden)"})


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

