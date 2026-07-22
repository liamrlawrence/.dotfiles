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
        local lsp_group = vim.api.nvim_create_augroup("LL.plugins_lsp-group", { clear = true })
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


        -- Lua
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


        -- C/C++
        local clangd_cmd = "clangd"

        if vim.fn.has("mac") == 1 and vim.fn.executable("/opt/homebrew/opt/llvm/bin/clangd") == 1 then
            clangd_cmd = "/opt/homebrew/opt/llvm/bin/clangd"
        end

        vim.lsp.config("clangd", {
            capabilities = capabilities,
            cmd = {
                clangd_cmd,
            },
            filetypes = { "c", "cpp", "c.header", "cpp.header", "objc", "objcpp", "cuda", "proto" },
        })


        -- Keybinds
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

        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "Register LSP buffer keymaps",
            group = lsp_group,
            callback = function(e)
                vim.keymap.set("n",                 "gd",           vim.lsp.buf.definition,         { buffer = e.buf, desc = "LSP Goto definition" })
                vim.keymap.set("n",                 "gD",           vim.lsp.buf.declaration,        { buffer = e.buf, desc = "LSP Goto declaration" })
                vim.keymap.set("n",                 "<Leader>/ls",  vim.lsp.buf.workspace_symbol,   { buffer = e.buf, desc = "LSP workspace symbol" })
                vim.keymap.set("n",                 "<Leader>lD",   vim.diagnostic.setloclist,      { buffer = e.buf, desc = "LSP diagnostics to location list" })
                vim.keymap.set({ "n", "i", "v", },  "<C-s>",        vim.lsp.buf.signature_help,     { buffer = e.buf, desc = "LSP display signature help" })
                vim.keymap.set("n",                 "<Leader>lr",   "<Cmd>w|e<CR>",                 { buffer = e.buf, desc = "LSP restart" })
                -- vim.keymap.set("n", "gr",           vim.lsp.buf.references,         { buffer = e.buf, desc = "LSP Get references" })         -- grr (default)
                -- vim.keymap.set("n", "<Leader>ld",   vim.diagnostic.open_float,      { buffer = e.buf, desc = "LSP open diagnostics" })       -- <C-w>d (default)
                -- vim.keymap.set("n", "<Leader>lca",  vim.lsp.buf.code_action,        { buffer = e.buf, desc = "LSP code action" })            -- gra (default)
                -- vim.keymap.set("n", "<Leader>lrn",  vim.lsp.buf.rename,             { buffer = e.buf, desc = "LSP rename" })                 -- grn (default)
                -- vim.keymap.set("n", "K",            vim.lsp.buf.hover,              { buffer = e.buf, desc = "LSP display hover" })          -- K (default)
                -- vim.keymap.set("n", "[d",           function() vim.diagnostic.jump({ count = -1 }) end, { buffer = e.buf, desc = "LSP Goto prev diagnostic" }) -- [d (default)
                -- vim.keymap.set("n", "]d",           function() vim.diagnostic.jump({ count = 1 }) end,  { buffer = e.buf, desc = "LSP Goto next diagnostic" }) -- ]d (default)
            end
        })
    end,
}

