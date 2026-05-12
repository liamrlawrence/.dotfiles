return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/nvim-cmp",
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

        -- Apply capabilities to all servers, then override per-server as needed
        vim.lsp.config("*", { capabilities = capabilities })

        require("mason-lspconfig").setup({
            -- ensure_installed = {
            --     "clangd",
            --     "pyright",
            --     "gopls", "templ",
            --     "ts_ls",
            --     "bashls",
            --     "dockerls",
            -- },
            automatic_enable = {
                exclude = { "lua_ls" },
            },
        })

        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                }
            }
        })
        vim.lsp.enable("lua_ls")

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-l>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
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
                source = true,
                header = "",
                prefix = "",
            },
        })

        -- LSP keybinds
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(e)
                vim.keymap.set("n", "gd",           vim.lsp.buf.definition,         { buffer = e.buf, desc = "LSP Goto definition" })
                vim.keymap.set("n", "gD",           vim.lsp.buf.declaration,        { buffer = e.buf, desc = "LSP Goto declaration" })
                vim.keymap.set("n", "<C-s>",        vim.lsp.buf.signature_help,     { buffer = e.buf, desc = "LSP display signature help" })
                vim.keymap.set("i", "<C-s>",        vim.lsp.buf.signature_help,     { buffer = e.buf, desc = "LSP display signature help" })
                vim.keymap.set("v", "<C-s>",        vim.lsp.buf.signature_help,     { buffer = e.buf, desc = "LSP display signature help" })
                vim.keymap.set("n", "<leader>lws",  vim.lsp.buf.workspace_symbol,   { buffer = e.buf, desc = "LSP workspace symbol" })
                vim.keymap.set("n", "<leader>lD",   vim.diagnostic.setloclist,      { buffer = e.buf, desc = "LSP diagnostics to location list" })
                -- vim.keymap.set("n", "gr",           vim.lsp.buf.references,         { buffer = e.buf, desc = "LSP Get references" })         -- grr (default)
                -- vim.keymap.set("n", "<leader>ld",   vim.diagnostic.open_float,      { buffer = e.buf, desc = "LSP open diagnostics" })       -- <C-w>d (default)
                -- vim.keymap.set("n", "<leader>lca",  vim.lsp.buf.code_action,        { buffer = e.buf, desc = "LSP code action" })            -- gra (default)
                -- vim.keymap.set("n", "<leader>lrn",  vim.lsp.buf.rename,             { buffer = e.buf, desc = "LSP rename" })                 -- grn (default)
                -- vim.keymap.set("n", "K",            vim.lsp.buf.hover,              { buffer = e.buf, desc = "LSP display hover" })          -- K (default)
                -- vim.keymap.set("n", "[d",           function() vim.diagnostic.jump({ count = -1 }) end, { buffer = e.buf, desc = "LSP Goto prev diagnostic" }) -- [d (default)
                -- vim.keymap.set("n", "]d",           function() vim.diagnostic.jump({ count = 1 }) end,  { buffer = e.buf, desc = "LSP Goto next diagnostic" }) -- ]d (default)
            end
        })
    end
}

