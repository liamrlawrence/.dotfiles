return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },

    config = function()
        require("nvim-treesitter.configs").setup {
            modules = {},
            ignore_install = {},
            ensure_installed = {
                "vim", "vimdoc", "query",
                "markdown",
                "bash",
                "lua",
                "python",
                "go", "templ",
                "rust",
                "c", "cpp",
                "javascript", "typescript",
                -- "org",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            indent = {
                enabled = true
            },

            highlight = {
                enable = true,
                disable = { "bash" },   -- HACK: Bash is broken for some reason

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
        }

        require("nvim-treesitter-textobjects").setup {
            select = {
                lookahead = true,
                selection_modes = {
                    ['@function.outer'] = 'V',
                    ['@parameter.outer'] = 'v',
                },
            },
            move = {
                set_jumps = true,
            },
        }

        local ts_select = require("nvim-treesitter-textobjects.select")
        local ts_move   = require("nvim-treesitter-textobjects.move")

        -- Select keymaps
        vim.keymap.set({ "x", "o" }, "ac", function() ts_select.select_textobject("@class.outer", "textobjects")     end, { desc = "Select around class" })
        vim.keymap.set({ "x", "o" }, "ic", function() ts_select.select_textobject("@class.inner", "textobjects")     end, { desc = "Select inside class" })
        vim.keymap.set({ "x", "o" }, "am", function() ts_select.select_textobject("@function.outer", "textobjects")  end, { desc = "Select around function" })
        vim.keymap.set({ "x", "o" }, "im", function() ts_select.select_textobject("@function.inner", "textobjects")  end, { desc = "Select inside function" })
        vim.keymap.set({ "x", "o" }, "aa", function() ts_select.select_textobject("@parameter.outer", "textobjects") end, { desc = "Select around parameter" })
        vim.keymap.set({ "x", "o" }, "ia", function() ts_select.select_textobject("@parameter.inner", "textobjects") end, { desc = "Select inside parameter" })

        -- Move keymaps
        vim.keymap.set({ "n", "x", "o" }, "]c", function() ts_move.goto_next_start("@class.outer", "textobjects")        end, { desc = "Next class start" })
        vim.keymap.set({ "n", "x", "o" }, "[c", function() ts_move.goto_previous_start("@class.outer", "textobjects")    end, { desc = "Previous class start" })
        vim.keymap.set({ "n", "x", "o" }, "]m", function() ts_move.goto_next_start("@function.outer", "textobjects")     end, { desc = "Next function start" })
        vim.keymap.set({ "n", "x", "o" }, "[m", function() ts_move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Previous function start" })
        vim.keymap.set({ "n", "x", "o" }, "]M", function() ts_move.goto_next_end("@function.outer", "textobjects")       end, { desc = "Next function end" })
        vim.keymap.set({ "n", "x", "o" }, "[M", function() ts_move.goto_previous_end("@function.outer", "textobjects")   end, { desc = "Previous function end" })
    end,
}

