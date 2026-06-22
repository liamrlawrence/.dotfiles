return {
    "nvim-orgmode/orgmode",
    dependencies = { "nvim-orgmode/org-bullets.nvim" },
    ft = { "org" },

    config = function()
        require("orgmode").setup({
            org_agenda_files = "~/Notes/**/*",
            org_default_notes_file = "~/Notes/refile.org",

            org_todo_keywords = { "TODO(t)", "BLOCKED", "WAITING", "IN-PROGRESS", "PAUSED", "|", "DONE", "CANCELLED" },
            org_todo_keyword_faces = {
                ["TODO"]        = ":foreground #F71040 :weight bold",
                ["BLOCKED"]     = ":foreground #E0306B :weight bold",
                ["WAITING"]     = ":foreground #F5C030 :weight bold",
                ["IN-PROGRESS"] = ":foreground #F5923E :weight bold :underline on",
                ["PAUSED"]      = ":foreground #C28A4E :weight bold :underline on",
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
        vim.api.nvim_create_autocmd("FileType", {
            desc = "Orgmode TODO sync clock on IN-PROGRESS",
            pattern = "org",
            callback = function(args)
                local function get_headline()
                    local ok, files = pcall(function() return require("orgmode").files end)
                    if not ok or not files then return nil end
                    local ok2, section = pcall(function() return files:get_closest_headline() end)
                    return ok2 and section or nil
                end

                local function todo_next_with_inprogress_clock()
                    local before = get_headline()
                    if not before then return end
                    local old_state = before:get_todo()

                    require("orgmode").action("org_mappings.todo_next_state")

                    local after = get_headline()
                    if not after then return end
                    local new_state = after:get_todo()
                    if new_state == old_state then return end

                    if new_state == "IN-PROGRESS" then
                        require("orgmode").action("clock.org_clock_in")
                    elseif old_state == "IN-PROGRESS" and after:is_clocked_in() then
                        require("orgmode").action("clock.org_clock_out")
                    end
                end

                -- HACK: Map keymaps to the string "<cmd>lua _G.fn()<cr>"
                -- (not a Lua function callback) so the todo menu runs in
                -- Neovim's protected context and skips the "Press ENTER" prompt.
                -- Global table so the <cmd> string can reach the fns.
                _G.__org = {
                    todo_next_state = todo_next_with_inprogress_clock
                }

                vim.keymap.set("n", "cit", "<cmd>lua _G.__org.todo_next_state()<cr>",   -- OVERRIDE:
                    { buffer = args.buf, desc = "org next todo state + IN-PROGRESS clock sync" })
            end,
        })

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

