return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        require("todo-comments").setup{
            keywords = {
                -- DONE: Finished
                DONE = {
                    icon = " ",
                    color = "#00A36C",
                    alt = {"FINISHED"},
                },
                -- DOC: Documentation, Info
                DOC = {
                    icon = "󰈙 ",
                    color = "#0096FF",
                    alt = {"DOCUMENTATION", "INFO"},
                },
            }
        }
    end
}

