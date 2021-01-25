call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'

call plug#end()

set number
set wrap

set rtp+=/Users/xiaogao/.config/nvim/plugin/*.vim'

let g:mapleader = "\<Space>"

nmap <silent> <Leader>e :Explorer<CR>
