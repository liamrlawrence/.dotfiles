vim.filetype.add({
    extension = {
        templ = "templ",
    },
    filename = {
        [".dockerignore"] = "gitignore",
    },
    pattern = {
        ["*%.env.*"] = "sh",
        [".*%.gitignore.*"] = "gitignore",
        [".*Dockerfile.*"] = "dockerfile",
    },
})

