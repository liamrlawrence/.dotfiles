local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s("fn", {
        t("local function "), i(1, "name"), t("("), i(2,
        "args"), t({ ")", "\t" }),
        i(3, "-- body"),
        t({ "", "end" }),
    }),
}

