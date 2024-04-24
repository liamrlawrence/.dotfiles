return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require("telescope").setup{
            defaults = {
                file_ignore_patterns = {
                    "%.git$",
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

        vim.keymap.set("n", "<leader>pF", function()
            builtin.find_files({
                hidden = true,
                no_ignore = true,
            })
        end, {desc = "Find files (including hidden)"})


        -- Search for a specific word
        vim.keymap.set("n", "<leader>pws", function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, {desc = "Find word"})

        vim.keymap.set("n", "<leader>pWs", function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, {desc = "Find capital Word"})


        -- Grep search
        vim.keymap.set("n", "<leader>ps", function()
            vim.ui.input({prompt = "Grep > "}, function(input)
                if not input or input == "" then
                    print("Grep canceled")
                    return
                end
                builtin.grep_string({search = input, ignore_case = false})
            end)
        end, {desc = "Grep string"})

        vim.keymap.set("n", "<leader>pS", function()
            vim.ui.input({prompt = "Grep (ignore case) > "}, function(input)
                if not input or input == "" then
                    print("Grep canceled")
                    return
                end
                builtin.grep_string({search = input, ignore_case = true})
            end)
        end, {desc = "Grep string (ignore case)"})


        -- Vim search
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, {desc = "Vim help"})
        vim.keymap.set("n", "<leader>vk", builtin.keymaps, {desc = "Vim keymaps"})
    end
}

