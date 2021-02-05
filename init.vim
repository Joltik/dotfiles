call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
Plug 't9md/vim-choosewin'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
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
autocmd BufEnter,FocusGained,InsertLeave * call IM_SelectDefault()

" function
let g:im_default = 'com.apple.keylayout.ABC'
function! IM_SelectDefault()
  let b:saved_im = system("im-select")
  if v:shell_error
    unlet b:saved_im
  else
    let l:a = system("im-select " . g:im_default)
  endif
endfunction

function! VisualStarSearchSet(cmdtype,...)
  let temp = @"
  normal! gvy
  if !a:0 || a:1 != 'raw'
    let @" = escape(@", a:cmdtype.'\*')
  endif
  let @/ = substitute(@", '\n', '\\n', 'g')
  let @/ = substitute(@/, '\[', '\\[', 'g')
  let @/ = substitute(@/, '\~', '\\~', 'g')
  let @/ = substitute(@/, '\.', '\\.', 'g')
  let @" = temp
endfunction

" keymaps
xnoremap * :<C-u>call VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>

nnoremap <silent> <C-k>  :<c-u>execute 'move -1-'. v:count1<CR>
nnoremap <silent> <C-j>  :<c-u>execute 'move +'. v:count1<CR>

nnoremap -<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap +<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

nmap <C-y> "*yw
xmap <C-y> "*y

let g:mapleader = "\<Space>"

nmap <silent> <Leader>e :Explorer<CR>
nmap <Leader>w <Plug>(choosewin)

nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>
