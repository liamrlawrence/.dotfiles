return {
    "folke/zen-mode.nvim",
    dependencies = { "folke/twilight.nvim" },

    config = function()
        local tw = require("twilight")
        local zm = require("zen-mode")
        local zm_view = require("zen-mode.view")
        local zen_group = vim.api.nvim_create_augroup("LL.plugins_zen-group", { clear = true })

        tw.setup({
            context = 10,
            exclude = { "netrw" },
        })

        zm.setup({
            window = {
                backdrop = 0.7,
                width    = 120,
                height   = 0.90,
            },
            plugins = {
                tmux     = { enabled = true },
                twilight = { enabled = true },
                gitsigns = { enabled = true },
            },
        })

        vim.api.nvim_create_autocmd("VimLeave", {
            desc = "Disable zen-mode on exit",
            group = zen_group,
            callback = function()
                if zm_view.is_open() then zm.close() end
            end,
        })
    end,

    keys = {
        { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen" },
    },
}

