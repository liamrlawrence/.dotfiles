return {
    name = "ghostty",
    ft = { "ghostty" },
    cond = (vim.env.GHOSTTY_RESOURCES_DIR or "") ~= "",
    dir = (vim.env.GHOSTTY_RESOURCES_DIR or "") .. "/../nvim/site",
}

