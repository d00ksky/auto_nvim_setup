-- Bootstrap packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- File navigation and fuzzy finding
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- File explorer with git integration
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  }

  -- Quick file switching
  use('theprimeagen/harpoon')

  -- Theme and UI
  use("folke/tokyonight.nvim")
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
  })
  
  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- Syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use('nvim-treesitter/playground')

  -- LSP and completion
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  -- Git integration
  use('tpope/vim-fugitive')
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  -- Development utilities
  use('mbbill/undotree')
  use {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
  }

  -- Code documentation
  use {
    "danymat/neogen",
    requires = "nvim-treesitter/nvim-treesitter",
  }

  -- Focus mode
  use("folke/zen-mode.nvim")

  -- Security
  use("laytan/cloak.nvim")

  -- Terminal integration
  use {"akinsho/toggleterm.nvim", tag = '*'}

  -- Claude Code integration helpers
  use('nvim-lua/plenary.nvim') -- Already included but ensuring it's there

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)