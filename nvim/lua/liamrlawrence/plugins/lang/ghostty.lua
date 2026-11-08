return {
    name = "ghostty",
    ft = { "ghostty" },
    dir = (vim.env.GHOSTTY_RESOURCES_DIR or "NO_GHOSTTY_RESOURCES_DIR") .. "/../nvim/site",
    cond = (vim.env.GHOSTTY_RESOURCES_DIR or "") ~= "",
}

