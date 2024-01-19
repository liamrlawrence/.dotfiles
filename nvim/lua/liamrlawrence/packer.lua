-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Fuzzy searching
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4'
    }

    -- Syntax coloring
    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    -- TODO Highlighting
    use('folke/todo-comments.nvim')

    -- Undo tree
    use('mbbill/undotree')

    -- Git wrapper
    use('tpope/vim-fugitive')

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
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

    -- Harpoon
    use('theprimeagen/harpoon')

    -- Themes
    use({'catppuccin/nvim', as = 'catppuccin'})
    use({'rose-pine/neovim', as = 'rose-pine'})
    use('folke/tokyonight.nvim')
    use('EdenEast/nightfox.nvim')
    use('rebelot/kanagawa.nvim')

end)

