call plug#begin('~/.vim/plugged')

Plug 'patstockwell/vim-monokai-tasty'
Plug 'yianwillis/vimcdoc'
Plug 't9md/vim-choosewin'

call plug#end()

set hlsearch
set scrolloff=5

set expandtab
set shiftwidth=2
set tabstop=2
set shortmess+=c

" style
set laststatus=2
set number
set cursorline
set signcolumn=number
set splitright
set fillchars=vert:¦

colorscheme vim-monokai-tasty

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE

" autocmd
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline
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


" keymaps
let g:mapleader = "\<Space>"

nmap <Leader>w <Plug>(choosewin)

nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>fc :vne<CR>:CocConfig<CR>
