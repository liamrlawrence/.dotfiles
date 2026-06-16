return {
    "nvim-orgmode/orgmode",
    dependencies = { "nvim-orgmode/org-bullets.nvim" },
    ft = { "org" },

    config = function()
        require("orgmode").setup({
            org_agenda_files = "~/Notes/**/*",
            org_default_notes_file = "~/Notes/refile.org",

            org_todo_keywords = { "TODO(t)", "WAITING", "IN-PROGRESS", "|", "DONE", "CANCELLED" },
            org_todo_keyword_faces = {
                ["TODO"]        = ":foreground #F74040 :weight bold",
                ["WAITING"]     = ":foreground #F5C030 :weight bold",
                ["IN-PROGRESS"] = ":foreground #F5923E :weight bold :slant italic",
                ["DONE"]        = ":foreground #26A65B :weight bold",
                ["CANCELLED"]   = ":foreground #8FA3D8 :weight bold",
            },

            win_split_mode = { "float", 0.75 },
            org_hide_emphasis_markers = true,
            org_startup_indented = true,
            org_tags_column = -80,

            mappings = {
                org = {
                    org_toggle_checkbox = "<C-t>",
                },
            },
        })
        vim.lsp.enable("org")
        require("org-bullets").setup()

        -- Keymaps
        vim.keymap.set("n", "<leader>oip", function()
            local ok, file = pcall(require("orgmode.api").current)
            if not ok or not file then
                vim.notify("Not in an org buffer", vim.log.levels.WARN)
                return
            end
            local headline = file:get_closest_headline()
            if not headline then
                vim.notify("No headline at cursor", vim.log.levels.WARN)
                return
            end

            local key = vim.fn.input("Property key: "):upper()
            if key == "" then return end
            local value = vim.fn.input(key .. ": ")

            -- value "" -> nil removes the property; otherwise upsert
            headline:set_property(key, value ~= "" and value or nil)
        end, { desc = "org set property on headline" })
    end,
}

