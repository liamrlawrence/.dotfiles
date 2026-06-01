local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node


return {
    s("checkbox", {
        t("- [ ] "),
        i(1, ""),
        i(0),
    }),
}

