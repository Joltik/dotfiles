if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'wincent/terminus'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'ctrlpvim/ctrlp.vim'

call plug#end()

set nocompatible
set encoding=utf-8
set backspace=indent,eol,start
set vb t_vb=
set cursorline
set hlsearch
set number
set signcolumn=number
set laststatus=2
set noshowmode
set wildmenu
set incsearch
set ignorecase
set smartcase
set scrolloff=5

set expandtab
set shiftwidth=2
set tabstop=2

colorscheme vim-monokai-tasty

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE

" 从右侧打开help文件
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif

" reset chinese input
let g:im_default = 'com.apple.keylayout.ABC'
autocmd BufEnter,FocusGained,InsertLeave * call IM_SelectDefault()
function! IM_SelectDefault()
  let b:saved_im = system("im-select")
  if v:shell_error
    unlet b:saved_im
  else
    let l:a = system("im-select " . g:im_default)
  endif
endfunction

" 打开文件时恢复上一次光标所在位置
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
			\ quit | endif


let NERDTreeMinimalUI=1
let NERDTreeMinimalMenu=1
let NERDTreeNaturalSort = 1
let NERDTreeStatusline='NERD_TREE'
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeWinSize = 30


let g:TerminusMouse=0

let g:lightline = {
      \   'colorscheme': 'monokai_tasty',
      \   'active': { 'right': [[ 'percent' ],[ 'filetype' ]] },
      \ }

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

xnoremap * :<C-u>call VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>


let g:mapleader = "\<Space>"


nnoremap <silent> <Leader>e :NERDTreeToggle<CR>


