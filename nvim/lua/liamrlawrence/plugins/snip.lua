return {
    "L3MON4D3/LuaSnip",
    dependencies = { "saadparwaiz1/cmp_luasnip" },
    event = "VeryLazy",

    config = function()
        local ls = require("luasnip")
        ls.add_snippets("org",    require("liamrlawrence.plugins.snips.snips_org"))
        ls.add_snippets("lua",    require("liamrlawrence.plugins.snips.snips_lua"))
        ls.add_snippets("python", require("liamrlawrence.plugins.snips.snips_python"))

        vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(1)  end, { desc = "Move to next item in snippet" })
        vim.keymap.set({ "i", "s" }, "<C-k>", function() ls.jump(-1) end, { desc = "Move to prev item in snippet" })
    end,
}

