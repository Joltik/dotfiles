call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
Plug 't9md/vim-choosewin'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'kyazdani42/nvim-web-devicons'

call plug#end()

set number
set wrap

set rtp+=/Users/xiaogao/.config/nvim/plugin/*.vim'


let g:nvcode_termcolors=256

colorscheme onedark

if (has("termguicolors"))
  set termguicolors
endif

hi Normal guibg=NONE ctermbg=NONE

let g:mapleader = "\<Space>"

nmap <silent> <Leader>e :Explorer<CR>
nmap <Leader>w <Plug>(choosewin)
