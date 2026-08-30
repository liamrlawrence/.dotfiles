return {
    "nvim-mini/mini.statuscolumn",
    version = false,

    config = function()
        local statuscolumn = require("mini.statuscolumn")
        local spec = {
            { format = "fs=l", sep = " ▏ " },
            { ltype = "virt", lnum = "•" },
            { ltype = "wrap", lnum = "↳" },
            { win = "inactive", sep = "   " },
        }
        statuscolumn.setup({ content = statuscolumn.gen_content.main(spec) })
    end,
}

