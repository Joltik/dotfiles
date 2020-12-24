call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 't9md/vim-choosewin'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Joltik/fzf-funky',{'on': 'FzfFunky'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf'
Plug 'chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', {'do': 'yarn install','for': ['javascript', 'typescript'] }
Plug 'scrooloose/nerdcommenter'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'mhinz/vim-startify'
Plug 'airblade/vim-rooter'
Plug 'voldikss/vim-floaterm'
Plug 'flazz/vim-colorschemes'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'kizza/actionmenu.nvim'

call plug#end()

" tail -f vim.log
" set verbosefile=vim.log

let g:mapleader = "\<Space>"
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
set laststatus=2
set signcolumn=auto
set fillchars=vert:¦
" set fillchars=vert:\  " vsplit line char

if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on
colorscheme colorsbox-material
set background=dark

hi Normal guibg=NONE
hi SignColumn guibg=NONE
hi VertSplit guifg=#3e3e3e guibg=NONE

hi GitGutterAdd    guifg=#59C369
hi GitGutterChange guifg=#FFF24A
hi GitGutterDelete guifg=#E24F59

let g:indentLine_color_gui = '#3e3e3e'

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif

lua require'colorizer'.setup(
      \ {'*';},
      \ {
      \   RGB      = true;
      \   RRGGBB   = true;
      \   names    = true;
      \   RRGGBBAA = true;
      \ })

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

" lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             ['git', 'readonly', 'filename', 'modified' ] ],
      \   'right':[
      \     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
      \   ],
      \ },
      \ 'component_function': {
      \   'git': 'fugitive#head',
      \ },
      \ }

" indentLine
let g:indentLine_fileTypeExclude = ['coc-explorer', 'startify']

" vim-easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

" coc
let g:coc_global_extensions = ['coc-explorer', 'coc-tsserver', 'coc-json', 'coc-vimlsp', 'coc-pairs', 'coc-fzf-preview']
autocmd FileType * let b:coc_pairs_disabled = ['<']
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
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

" nerdcommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCustomDelimiters = {
      \ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
      \}

" rg
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
let g:coc_fzf_preview = 'right'
let g:fzf_funky_opts = [fzf_opt]

" vim-bookmarks
let g:bookmark_no_default_key_mappings = 1

" floaterm
let g:floaterm_autoclose = 1
let g:floaterm_width = 0.3
let g:floaterm_height = 0.5
let g:floaterm_position = 'topright'
let g:floaterm_keymap_new = '<Leader>ta'
let g:floaterm_keymap_toggle = '<Leader>tt'
let g:floaterm_keymap_prev   = '<Leader>tp'
let g:floaterm_keymap_next   = '<Leader>tn'
let g:floaterm_keymap_kill = '<Leader>tk'

" vim-prettier
let g:prettier#quickfix_enabled = 0

" gitgutter
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0

" vim-plug
let g:plug_window = 'vertical rightbelow new'

" actionmenu
func! Demo()
  let l:items = [
        \ { 'word': 'First', 'abbr': '1st', 'user_data': 'Custom data 1' },
        \ { 'word': 'Second', 'abbr': '2nd', 'user_data': 'Custom data 2' },
        \ { 'word': 'Third', 'abbr': '3rd', 'user_data': 'Custom data 3' }
        \ ]

  call actionmenu#open(
        \ l:items,
        \ { index, item -> Callback(index, item) }
        \ )
endfunc

func! Callback(index, item)
  if a:index >= 0
    echo "Custom data is ". a:item['user_data']
  endif
endfunc

nnoremap <silent> <Leader>a :call Demo()<CR>

" map
nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>fc :CocConfig<CR>

nmap <Leader>ss <Plug>(easymotion-s2)
nmap <Leader>w <Plug>(choosewin)
nmap <silent> <Leader>e :CocCommand explorer --sources=file+<CR>

nmap <Leader>cf :Autoformat<CR>
autocmd FileType javascript,typescript nmap <buffer> <Leader>cf <Plug>(Prettier)

nmap <Leader>gn <Plug>(GitGutterNextHunk)
nmap <Leader>gp <Plug>(GitGutterPrevHunk)
nmap <Leader>gi <Plug>(GitGutterPreviewHunk)
nmap <Leader>gs :GFiles?<CR>
nmap <Leader>gd :vert Git diff<CR>
nmap <Leader>gf :Gvdiffsplit<CR>
nmap <Leader>gu <Plug>(GitGutterUndoHunk)

map <Leader>cc <plug>NERDCommenterToggle
map <Leader>cm <plug>NERDCommenterMinimal

map <Leader>sf :Files<CR>
map <Leader>sb :Buffers<CR>
map <Leader>sw :Rg<CR>
map <Leader>sh :History<CR>
map <Leader>sc :History:<CR>
nnoremap <Leader>su :FzfFunky<CR>

nmap <silent> <Leader>jd <Plug>(coc-definition)
nmap <silent> <Leader>jy <Plug>(coc-type-definition)
nmap <silent> <Leader>ji <Plug>(coc-implementation)
nmap <silent> <Leader>jr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <Leader>sd :call <SID>show_documentation()<CR>

nmap <Leader>ba <Plug>BookmarkToggle
nmap <Leader>bc <Plug>BookmarkClearAll
nmap <Leader>bl :CocCommand fzf-preview.Bookmarks<CR>

nmap <silent> <C-y> :.w !pbcopy<CR><CR>
vnoremap <silent> <C-y> :<CR>:let @a=@" \| execute "normal! vgvy" \| let res=system("pbcopy", @") \| let @"=@a<CR>
