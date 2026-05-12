return {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
    },

    config = function()
        local ls = require("luasnip")
        ls.add_snippets("lua", require("liamrlawrence.plugins.snips.snips_lua"))
        ls.add_snippets("python", require("liamrlawrence.plugins.snips.snips_python"))

        vim.keymap.set({ "i", "s" }, "<C-j>", function() require("luasnip").jump(1) end,  { desc = "Move to next item in snippet" })
        vim.keymap.set({ "i", "s" }, "<C-k>", function() require("luasnip").jump(-1) end, { desc = "Move to prev item in snippet" })
    end
}

