call plug#begin('~/.vim/plugged')

Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 't9md/vim-choosewin'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'chiel92/vim-autoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'MattesGroeger/vim-bookmarks'

call plug#end()

let g:mapleader = "\<Space>"
set nocompatible
set number
set cursorline
set scrolloff=10
set hidden
set nobackup
set nowritebackup
set splitright
set updatetime=300
set shortmess+=c
set list lcs=tab:\|\  " indentLine
if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on
colorscheme onedark
let g:onedark_hide_endofbuffer=1

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif

" reset chinese input
let g:im_default = 'com.apple.keylayout.ABC'
autocmd FocusGained,InsertLeave * call IM_SelectDefault()
function! IM_SelectDefault()
  let b:saved_im = system("im-select")
  if v:shell_error
    unlet b:saved_im
  else
    let l:a = system("im-select " . g:im_default)
  endif
endfunction

let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             ['git', 'readonly', 'filename', 'modified' ] ],
      \   'right':[
      \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
      \   ],
      \ },
      \ 'component_function': {
      \   'git': 'LightlineGitStatus',
      \ },
      \ }

function! LightlineGitStatus() abort
  let status = get(g:, 'coc_git_status', '')
  return winwidth(0) > 120 ? status : ''
endfunction

let g:indentLine_fileTypeExclude = ['coc-explorer']


" vim-easymotion
let g:EasyMotion_do_mapping = 0
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1


" coc
let g:coc_global_extensions = ['coc-explorer', 'coc-tsserver', 'coc-json', 'coc-git', 'coc-vimlsp', 'coc-pairs', 'coc-fzf-preview']
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
autocmd CursorHold * silent call CocActionAsync('highlight')
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" https://github.com/weirongxu/coc-explorer/wiki/Highlight
hi CocExplorerGitUntracked guifg=#61AFEF

" nerdcommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCustomDelimiters = {
      \ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
      \}

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" fzf
let fzf_float_rate = 0.6
let fzf_opt = '--layout=reverse'
let $FZF_DEFAULT_OPTS = fzf_opt
let g:fzf_layout = { 'window': { 'width': fzf_float_rate, 'height': fzf_float_rate } }
let g:fzf_preview_floating_window_rate = fzf_float_rate


nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>fc :CocConfig<CR>

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
nmap <Leader>s <Plug>(easymotion-overwin-f2)
nmap <Leader>w <Plug>(choosewin)
nmap <silent> <Leader>e :CocCommand explorer --sources=file+<CR>

nmap <Leader>cf :Autoformat<CR>

nmap <Leader>gn <Plug>(coc-git-nextchunk)
nmap <Leader>gp <Plug>(coc-git-prevchunk)
nmap <Leader>gi <Plug>(coc-git-chunkinfo)
nmap <Leader>gc <Plug>(coc-git-nextconflict)
nmap <Leader>gs :GFiles?<CR>

map <Leader>cc <plug>NERDCommenterToggle
map <Leader>cm <plug>NERDCommenterMinimal

map <Leader>sf :Files<CR>
map <Leader>sb :Buffers<CR>
map <Leader>sw :Rg<CR>
map <Leader>sh :History<CR>
map <Leader>sc :History:<CR>

nmap <silent> <Leader>jd <Plug>(coc-definition)
nmap <silent> <Leader>jy <Plug>(coc-type-definition)
nmap <silent> <Leader>ji <Plug>(coc-implementation)
nmap <silent> <Leader>jr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <Leader>sd :call <SID>show_documentation()<CR>

nmap <Leader>ba <Plug>BookmarkToggle
nmap <Leader>bc <Plug>BookmarkClearAll
nmap <Leader>bl :CocCommand fzf-preview.Bookmarks<CR>
