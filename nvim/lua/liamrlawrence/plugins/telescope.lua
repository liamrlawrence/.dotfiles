return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        require("telescope").setup{
            defaults = {
                file_ignore_patterns = {
                    "%.git$",
                    "venv",
                    "node_modules",
                    "static/vendor",
                }
            }
        }
        local builtin = require("telescope.builtin")


        -- Git file search
        vim.keymap.set("n", "<leader>/g", builtin.git_files, { desc = "Git files" })


        -- File search
        vim.keymap.set("n", "<leader>/f", builtin.find_files, { desc = "Find files" })

        vim.keymap.set("n", "<leader>/F", function()
            builtin.find_files({
                hidden = true,
                no_ignore = true,
            })
        end, { desc = "Find files (including hidden)" })


        -- Search for a specific word
        vim.keymap.set("n", "<leader>/w", function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, { desc = "Find word" })

        vim.keymap.set("n", "<leader>/W", function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, { desc = "Find capital Word" })


        -- Grep search
        vim.keymap.set("n", "<leader>/s", function()
            vim.ui.input({ prompt = "Grep > " }, function(input)
                if not input then
                    return
                end
                builtin.grep_string({ search = input })
            end)
        end, { desc = "Grep string" })

        vim.keymap.set("n", "<leader>/S", function()
            builtin.live_grep()
        end, { desc = "Live Grep search" })

        vim.keymap.set("n", "<leader>/r", function()
            vim.ui.input({ prompt = "Grep (regex) > " }, function(input)
                if not input then
                    return
                end
                builtin.grep_string({ search = input, use_regex = true })
            end)
        end, { desc = "Grep string (regex)" })

        vim.keymap.set("n", "<leader>/R", function()
            builtin.live_grep({ use_regex = true })
        end, { desc = "Live Grep search (regex)" })


        -- Vim search
        vim.keymap.set("n", "<leader>/vh", builtin.help_tags,   { desc = "Vim help" })
        vim.keymap.set("n", "<leader>/vk", builtin.keymaps,     { desc = "Vim keymaps" })
    end
}

