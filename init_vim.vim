if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'patstockwell/vim-monokai-tasty'
Plug 'yianwillis/vimcdoc'
Plug 'wincent/terminus'
Plug 't9md/vim-choosewin'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

set nocompatible
set encoding=utf-8
set backspace=indent,eol,start
set hlsearch
set cursorline
set number
set signcolumn=number
set wildmenu
set incsearch
" set ignorecase
set smartcase
set scrolloff=5

if has('autocmd')
	filetype plugin indent on
endif

if has('syntax')
	syntax enable
	syntax on
endif

set noerrorbells
set novisualbell
set t_vb=

set expandtab
set shiftwidth=2
set tabstop=2

set shortmess+=c
set completeopt+=menuone,noinsert
set hidden

colorscheme vim-monokai-tasty

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE

" 从右侧打开help文件
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif

autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

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


let g:vim_jsx_pretty_colorful_config = 1
let g:TerminusMouse=0


" coc
let g:coc_config_home = '$HOME/.config/nvim'
let g:coc_global_extensions = ['coc-explorer', 'coc-tsserver', 'coc-json', 'coc-vimlsp', 'coc-pairs', 'coc-fzf-preview', 'coc-snippets']
autocmd FileType * let b:coc_pairs_disabled = ['<']
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <TAB>
			\ pumvisible() ? coc#_select_confirm() :
			\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	elseif (coc#rpc#ready())
		call CocActionAsync('doHover')
	else
		execute '!' . &keywordprg . " " . expand('<cword>')
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

xnoremap * :<C-u>call VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>

function! OpenNetrw()
  let empty_buffer = line('$') == 1 && getline(1) == ''
  if empty_buffer
    exe ':Explore'
  else
    exe ':Vex!'
  endif
endfunction

let g:mapleader = "\<Space>"

nnoremap <silent> <Leader>e :call OpenNetrw()<CR>
nmap <Leader>w <Plug>(choosewin)

" move
nnoremap <silent> <C-k>  :<c-u>execute 'move -1-'. v:count1<CR>
nnoremap <silent> <C-j>  :<c-u>execute 'move +'. v:count1<CR>

" add space
nnoremap -<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap +<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" n=down N=up
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" copy
nmap <C-y> "*yw
xmap <C-y> "*y
