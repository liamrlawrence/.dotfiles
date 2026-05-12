local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s("main", {
        t({ 'if __name__ == "__main__":', "\t" }),
        i(1, "pass"),
        i(0),
    }),

    s("def", {
        t("def "), i(1, "name"), t("("), i(2, "args"), t({
            "):", "\t" }),
            i(3, "pass"),
            i(0),
    }),

    s("class", {
        t("class "), i(1, "Name"), t({ ":", "\t" }),
        t("def __init__(self"), t(", "), i(2, "args"), t({
            "):", "\t\t" }),
            i(3, "pass"),
            i(0),
        }),
}

