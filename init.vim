call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 't9md/vim-choosewin'
Plug 'airblade/vim-rooter'
Plug 'mhinz/vim-startify'

call plug#end()

set hlsearch
set incsearch
set scrolloff=5

set expandtab
set shiftwidth=2
set tabstop=2
set shortmess+=c

" style
set laststatus=2
set number
set cursorline
set signcolumn=yes
set splitright
set fillchars=vert:¦

colorscheme vim-monokai-tasty
set background=dark

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE

" plug setting
let g:plug_window = 'vertical rightbelow new'
let g:lightline = {
			\ 'colorscheme': 'wombat',
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\             ['gitbranch', 'readonly', 'filename', 'modified' ] ],
			\   'right':[
			\     [ 'filetype', 'fileencoding', 'percent' ]
			\   ],
			\ },
			\ 'component_function': {
			\   'gitbranch': 'FugitiveHead'
			\ },
			\ }
" vim-easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
" nerdcommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCustomDelimiters = {
			\ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
			\}
" vim-prettier
let g:prettier#quickfix_enabled = 0
" gitgutter
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
" coc
let g:coc_config_home = '$HOME/.config/nvim'
let g:coc_global_extensions = ['coc-explorer', 'coc-tsserver', 'coc-json', 'coc-vimlsp', 'coc-pairs', 'coc-snippets']
let g:coc_snippet_next = '<tab>'
" fzf
let $FZF_DEFAULT_OPTS = '--layout=reverse'
let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.6} }

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
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
autocmd FileType * let b:coc_pairs_disabled = ['<']

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

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" rg
function! RipgrepFzf(query, fullscreen)
	let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
	let initial_command = printf(command_fmt, shellescape(a:query))
	let reload_command = printf(command_fmt, '{q}')
	let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
	call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" keymaps
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <TAB>
			\ pumvisible() ? coc#_select_confirm() :
			\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()

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

nmap <silent> <Leader>e :CocCommand explorer --sources=file+<CR>
nmap <Leader>w <Plug>(choosewin)

map <Leader>cc <plug>NERDCommenterToggle
map <Leader>cm <plug>NERDCommenterMinimal
nmap <Leader>cf <Plug>(Prettier)
autocmd FileType vim nmap <buffer> <Leader>cf :Autoformat<CR>

nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>fc :vne<CR>:CocConfig<CR>

nmap <Leader>gn <Plug>(GitGutterNextHunk)
nmap <Leader>gp <Plug>(GitGutterPrevHunk)
nmap <Leader>gi <Plug>(GitGutterPreviewHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)

nmap <Leader>ss <Plug>(easymotion-s2)

map <silent> <Leader>sf :Files<CR>
map <silent> <Leader>sb :Buffers<CR>
map <silent> <Leader>sh :History<CR>
map <silent> <Leader>sc :History:<CR>
map <silent> <Leader>sg :GFiles?<CR>
nnoremap <silent> <Leader>sw :Rg<CR>
xnoremap <silent> <Leader>sw y:Rg <C-R>"<CR>
