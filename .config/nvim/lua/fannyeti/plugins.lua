vim.cmd [[packadd packer.nvim]]

return require('packer').startup({
    function(use)
        use('wbthomason/packer.nvim')
        use({
            'nvim-telescope/telescope.nvim',
            tag = '0.1.1',
            requires = { { 'nvim-lua/plenary.nvim' } }
        })

        -- treesitter
        use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
        use { 'nvim-treesitter/nvim-treesitter-textobjects',
            after = 'nvim-treesitter',
        }
        use({
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end,
        })
        use('windwp/nvim-ts-autotag')
        use('rstacruz/vim-closer')

        -- lsp
        use({ 'jose-elias-alvarez/null-ls.nvim',
            'jay-babu/mason-null-ls.nvim' })
        use({
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v2.x',
            requires = {
                -- LSP Support
                { 'neovim/nvim-lspconfig' },
                { 'williamboman/mason.nvim' },
                { 'williamboman/mason-lspconfig.nvim' },

                -- Autocompletion
                { 'hrsh7th/nvim-cmp' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
                { 'saadparwaiz1/cmp_luasnip' },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/cmp-nvim-lua' },

                -- Snippets
                { 'L3MON4D3/LuaSnip' },
                { 'rafamadriz/friendly-snippets' },
            }
        })

        -- ltools
        use('jalvesaq/Nvim-R')
        use('lervag/vimtex')
        use('mickael-menu/zk-nvim')
        use('preservim/vim-markdown')
        use({
            "iamcco/markdown-preview.nvim",
            run = "cd app && npm install",
            setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
            ft = { "markdown" },
        })
        use { "nvim-telescope/telescope-bibtex.nvim",
            config = function()
                require "telescope".load_extension("bibtex")
            end,
        }

        -- xtools
        use('theprimeagen/harpoon')
        use("theprimeagen/refactoring.nvim")
        use("folke/trouble.nvim")
        use('mbbill/undotree')
        use('phaazon/hop.nvim')
        use('tpope/vim-surround')
        use("laytan/cloak.nvim")
        use('folke/zen-mode.nvim')

        -- git
        use('tpope/vim-fugitive')
        -- use('lewis6991/gitsigns.nvim')
        -- use('sindrets/diffview.nvim')

        -- colorscheme
        use('https://gitlab.com/__tpb/acme.nvim')
        use('ellisonleao/gruvbox.nvim')

        --others
        use("eandrju/cellular-automaton.nvim")
        use('tidalcycles/vim-tidal')
        use({
            'norcalli/nvim-colorizer.lua',
            config = function()
                require('colorizer').setup()
            end
        })
    end,
    --packer ui
    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'rounded' })
            end
        },
        profile = {
            enable = true,
            threshold = 1
        }
    }
})
