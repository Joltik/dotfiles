call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
Plug 't9md/vim-choosewin'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'chiel92/vim-autoformat'
Plug 'norcalli/nvim-colorizer.lua'

call plug#end()

set hlsearch
set incsearch
set scrolloff=5
set updatetime=300
set shortmess+=c
set nobackup
set nowritebackup
" tabsize
set expandtab
set shiftwidth=2
set tabstop=2
" style
set noshowmode
set laststatus=2
set number
set cursorline
set signcolumn=number
set splitright
set fillchars=vert:¦

set rtp+=/Users/xiaogao/.config/nvim/plugin/*.vim'

let g:nvcode_termcolors=256

colorscheme onedark

if (has("termguicolors"))
  set termguicolors
endif

hi Normal guibg=NONE ctermbg=NONE

lua require('plug')

let g:mapleader = "\<Space>"

nmap <silent> <Leader>e :Explorer<CR>
nmap <Leader>w <Plug>(choosewin)

autocmd FileType vim,lua nmap <buffer> <Leader>cf :Autoformat<CR>
