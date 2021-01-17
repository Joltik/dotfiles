call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
Plug 'tweekmonster/startuptime.vim'
Plug 'christianchiarulli/nvcode-color-schemes.vim'

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
set laststatus=2
set number
set cursorline
set signcolumn=number
set splitright
set fillchars=vert:¦

let g:nvcode_termcolors=256

syntax on
colorscheme onedark
set background=dark

if (has("termguicolors"))
  set termguicolors
endif

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE guifg=#455a64 ctermfg=239
hi EndOfBuffer guibg=NONE ctermbg=NONE guifg=#282c34 ctermfg=249
