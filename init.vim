call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
Plug 't9md/vim-choosewin'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'airblade/vim-gitgutter'

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
set signcolumn=auto
set splitright
set fillchars=vert:¦
set wrap
set showtabline=1

set rtp+=/Users/xiaogao/.config/nvim/plugin/*.vim'

let g:nvcode_termcolors=256

syntax on
colorscheme onedark

if (has("termguicolors"))
  set termguicolors
endif

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE guifg=#455a64 ctermfg=239
hi EndOfBuffer guibg=NONE ctermbg=NONE guifg=#282c34 ctermfg=249

lua require('plug')

" plug setting
let g:plug_window = 'vertical rightbelow new'
" autocmd
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \  exe "normal! g`\"" |
      \ endif
" gitgutter
let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_modified = '▌'
let g:gitgutter_sign_removed = '▌'
let g:gitgutter_sign_removed_first_line = '▌'
let g:gitgutter_sign_removed_above_and_below = '▌'
let g:gitgutter_sign_modified_removed = '▌'

" keymaps
let g:mapleader = "\<Space>"

nmap <silent> <Leader>e :Pandatree<CR>
nmap <Leader>w <Plug>(choosewin)

nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>
