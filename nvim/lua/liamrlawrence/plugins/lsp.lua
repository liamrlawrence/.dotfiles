return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            -- ensure_installed = {
            --     "lua_ls",
            --     "bashls",
            --     "pyright",
            --     "gopls", "templ",
            --     "clangd",
            --     "tsserver",
            --     "dockerls",
            -- },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-l>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
            }, {
                { name = "buffer" },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })


        -- LSP keybinds
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(e)
                vim.keymap.set("n", "gd",           vim.lsp.buf.definition,         { buffer = e.buf, desc = "LSP Goto defintion" })
                vim.keymap.set("n", "gD",           vim.lsp.buf.declaration,        { buffer = e.buf, desc = "LSP Goto declaration" })
                vim.keymap.set("n", "gr",           vim.lsp.buf.references,         { buffer = e.buf, desc = "LSP Get references" })         -- grr
                vim.keymap.set("n", "<leader>lws",  vim.lsp.buf.workspace_symbol,   { buffer = e.buf, desc = "LSP workspace symbol" })
                vim.keymap.set("n", "<leader>ld",   vim.diagnostic.open_float,      { buffer = e.buf, desc = "LSP open diagnostics" })
                vim.keymap.set("n", "<leader>lca",  vim.lsp.buf.code_action,        { buffer = e.buf, desc = "LSP code action" })            -- gra
                vim.keymap.set("n", "<leader>lrn",  vim.lsp.buf.rename,             { buffer = e.buf, desc = "LSP rename" })                 -- grn
                vim.keymap.set("n", "K",            vim.lsp.buf.hover,              { buffer = e.buf, desc = "LSP display hover" })          -- K
                vim.keymap.set("n", "<C-s>",        vim.lsp.buf.signature_help,     { buffer = e.buf, desc = "LSP display signature help" }) -- <C-s>
                vim.keymap.set("i", "<C-s>",        vim.lsp.buf.signature_help,     { buffer = e.buf, desc = "LSP display signature help" })
                vim.keymap.set("v", "<C-s>",        vim.lsp.buf.signature_help,     { buffer = e.buf, desc = "LSP display signature help" })
                vim.keymap.set("n", "[d",           vim.diagnostic.goto_prev,       { buffer = e.buf, desc = "LSP Goto prev diagnostic" })
                vim.keymap.set("n", "]d",           vim.diagnostic.goto_next,       { buffer = e.buf, desc = "LSP Goto next diagnostic" })
            end
        })
    end
}

