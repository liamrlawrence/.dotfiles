return {
    "simonwinther/cppman.nvim",
    dependencies = { "ibhagwan/fzf-lua" },
    version = "*",
    cmd = { "CPPMan" },

    init = function()
        local cppman_group = vim.api.nvim_create_augroup("LL.plugins_cppman-group", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            desc = "Register cppman keymaps",
            group = cppman_group,
            pattern = { "c", "cpp" },
            callback = function(args)
                vim.keymap.set("n", "<Leader>/mk", function()
                    require("cppman").search()
                end, { buffer = args.buf, desc = "[C++] keyword search" })

                vim.keymap.set("n", "<Leader>/mu", function()
                    require("cppman").open_for(vim.fn.expand("<cword>"))
                end, { buffer = args.buf, desc = "[C++] open under cursor" })
            end,
        })
    end,

    config = function()
        require("cppman").setup({
            picker = {
                provider = "fzf-lua",
            },
        })
    end,
}

