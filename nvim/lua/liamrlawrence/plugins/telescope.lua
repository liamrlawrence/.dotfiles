return {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",

    config = function()
        require("telescope").setup{
            defaults = {
                file_ignore_patterns = {
                    "%.git/",
                    "venv/",
                    "node_modules/",
                    "static/vendor",
                },
                mappings = {
                    n = {
                        ["<M-q>"] = require("telescope.actions").send_to_loclist + require("telescope.actions").open_loclist,
                    },
                    i = {
                        ["<M-q>"] = require("telescope.actions").send_to_loclist + require("telescope.actions").open_loclist,
                    },
                },
            },
            pickers = {
                find_files = {
                    follow = true,
                },
                grep_string = {
                    additional_args = { "--follow" },
                },
                live_grep = {
                    additional_args = { "--follow" },
                },
            },
        }
        local telescope = require("telescope.builtin")


        -- Git file search
        vim.keymap.set("n", "<leader>/g", telescope.git_files, { desc = "Find git files" })


        -- File search
        vim.keymap.set("n", "<leader>/f", function()
            telescope.find_files({
                hidden = true,
            })
        end, { desc = "Find files" })

        vim.keymap.set("n", "<leader>/F", function()
            telescope.find_files({
                hidden = true,
                no_ignore = true,
            })
        end, { desc = "Find files (including ignored)" })


        -- Word search
        vim.keymap.set("n", "<leader>/w", function()
            local word = vim.fn.expand("<cword>")
            telescope.grep_string({ search = word })
        end, { desc = "Find word" })

        vim.keymap.set("n", "<leader>/W", function()
            local word = vim.fn.expand("<cWORD>")
            telescope.grep_string({ search = word })
        end, { desc = "Find capital Word" })


        -- Grep search
        vim.keymap.set("n", "<leader>/s", function()
            vim.ui.input({ prompt = "Grep > " }, function(input)
                if not input then
                    return
                end
                telescope.grep_string({ search = input })
            end)
        end, { desc = "Grep search" })

        vim.keymap.set("n", "<leader>/S", function()
            telescope.live_grep()
        end, { desc = "Live Grep search" })

        vim.keymap.set("n", "<leader>/t", function()
            telescope.live_grep({ search_dirs = { vim.fn.expand("%:p") } })
        end, { desc = "Grep this file" })

        vim.keymap.set("n", "<leader>/r", function()
            vim.ui.input({ prompt = "Grep (regex) > " }, function(input)
                if not input then
                    return
                end
                telescope.grep_string({ search = input, use_regex = true })
            end)
        end, { desc = "Grep search (regex)" })

        vim.keymap.set("n", "<leader>/R", function()
            telescope.live_grep({ use_regex = true })
        end, { desc = "Live Grep search (regex)" })


        -- Colorscheme search
        vim.keymap.set("n", "<leader>/c", function()
            telescope.colorscheme({
                enable_preview = true,
                layout_config = {
                    preview_cutoff = 0,
                    width = 0.9,
                    horizontal = {
                        preview_width = 0.70,
                    },
                },
            })
        end, { desc = "Search colorschemes" })


        -- Vim search
        vim.keymap.set("n", "<leader>/vh", telescope.help_tags, { desc = "Search vim help" })
        vim.keymap.set("n", "<leader>/vk", telescope.keymaps,   { desc = "Search vim keymaps" })
    end,
}

