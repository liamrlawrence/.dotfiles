return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    build = ":TSUpdate",

    init = function()
        local treesitter_group = vim.api.nvim_create_augroup("LL.plugins_treesitter-group", { clear = true })
        local ensure_installed = {
            "vim", "vimdoc", "query",
            "markdown",
            "bash",
            "lua",
            "python",
            "go", "templ",
            "rust",
            "c", "cpp",
            "javascript", "typescript",
        }
        local already_installed = require("nvim-treesitter.config").get_installed()
        local to_install = vim.iter(ensure_installed)
            :filter(function(p) return not vim.tbl_contains(already_installed, p) end)
            :totable()
        if #to_install > 0 then
            require("nvim-treesitter").install(to_install)
        end

        -- Highlighting and indentation (replaces highlight/indent opts)
        vim.api.nvim_create_autocmd("FileType", {
            desc = "Enable treesitter highlighting and indentation per filetype",
            group = treesitter_group,
            callback = function()
                if vim.bo.filetype == "bash" then return end  -- HACK: Bash is broken
                pcall(vim.treesitter.start)
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })

        -- Textobjects
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

