return {
    "nvim-orgmode/orgmode",
    dependencies = { "nvim-orgmode/org-bullets.nvim" },
    event = "VeryLazy",
    ft = { "org" },

    config = function()
        require("orgmode").setup({
            org_agenda_files = "~/Notes/**/*",
            org_default_notes_file = "~/Notes/refile.org",

            org_todo_keywords = { "TODO", "WAITING", "IN-PROGRESS", "|", "DONE", "CANCELLED" },
            org_todo_keyword_faces = {
                ["TODO"]        = ":foreground #F74040 :weight bold",
                ["WAITING"]     = ":foreground #F5C030 :weight bold",
                ["IN-PROGRESS"] = ":foreground #F5923E :slant italic",
                ["DONE"]        = ":foreground #26A65B :weight bold",
                ["CANCELLED"]   = ":foreground #8FA3D8 :weight bold",
            },

            win_split_mode = "float",   -- Floating agenda

            mappings = {
                org = {
                    org_toggle_checkbox = "<C-t>",
                },
            },
        })


        require("org-bullets").setup()

        vim.lsp.enable("org")
    end,
}

