return {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    dependencies = {
        "nvim-orgmode/org-bullets.nvim",
    },

    config = function()
        require("orgmode").setup({
            org_agenda_files = "~/Notes/**/*",
            org_default_notes_file = "~/Notes/refile.org",
            mappings = {
                org = {
                    org_toggle_checkbox = "<C-t>",
                },
            },
        })

        require("org-bullets").setup()
    end
}

