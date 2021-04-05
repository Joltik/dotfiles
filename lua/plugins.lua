return require('packer').startup(function()
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'christianchiarulli/nvcode-color-schemes.vim' }
  use { 'neovim/nvim-lspconfig' }
  use { 'nvim-lua/completion-nvim' }
  use { 'windwp/nvim-ts-autotag' }
end)