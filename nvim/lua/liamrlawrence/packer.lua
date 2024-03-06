-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- Surround
    use {
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({})
        end
    } 

    -- Fuzzy searching
    use {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4"
    }

    -- Harpoon
    use("theprimeagen/harpoon")

    -- Git
    use("tpope/vim-fugitive")
    use("airblade/vim-gitgutter")

    -- Syntax coloring
    use("nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"})

    -- LSP
    use {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = {
            -- LSP Support
            {"neovim/nvim-lspconfig"},
            {"williamboman/mason.nvim"},
            {"williamboman/mason-lspconfig.nvim"},

            -- Autocompletion
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-buffer"},
            {"hrsh7th/cmp-path"},
            {"saadparwaiz1/cmp_luasnip"},
            {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-nvim-lua"},

            -- Snippets
            {"L3MON4D3/LuaSnip"},
            {"rafamadriz/friendly-snippets"},
        }
    }

    -- File tree
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        after = "nvim-web-devicons",
        requires = { 
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    }

    -- Undo tree
    use("mbbill/undotree")

    -- Themes
    use({"catppuccin/nvim", as = "catppuccin"})
    use({"rose-pine/neovim", as = "rose-pine"})
    use("folke/tokyonight.nvim")
    use("EdenEast/nightfox.nvim")
    use("rebelot/kanagawa.nvim")
end)

