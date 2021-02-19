local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

vim.api.nvim_command('autocmd BufWritePost plugins.lua PackerCompile')

return require('packer').startup({function()
  use 'yianwillis/vimcdoc'
  use 't9md/vim-choosewin'
  use 'christianchiarulli/nvcode-color-schemes.vim'
  use 'norcalli/nvim-colorizer.lua'
  use 'airblade/vim-gitgutter'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'neovim/nvim-lspconfig'
  use { 'neoclide/coc.nvim', branch = 'release' }
end, config = { auto_clean = false }})
