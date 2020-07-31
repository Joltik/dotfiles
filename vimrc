call plug#begin('~/.vim/plugged')

Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-rooter'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'easymotion/vim-easymotion'
Plug 'prettier/vim-prettier', {'do': 'yarn install','for': ['javascript', 'typescript'] }
Plug 'chiel92/vim-autoformat'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tracyone/fzf-funky',{'on': 'FzfFunky'}
Plug 'Yggdroot/indentLine'
Plug 'elzr/vim-json'
Plug 'antoinemadec/coc-fzf'

call plug#end()

" 系统设置
set termguicolors " 真彩色显示
set number " 显示行号
set cursorline " 高亮显示当前行
set hlsearch " 高亮显示搜索内容
set clipboard=unnamed " 使用系统剪贴板
set splitright " 设置新窗口在右边
set laststatus=2 " 一直显示状态栏
set showtabline=2 " 一直显示Tab
set autoindent " 把当前行的对起格式应用到下一行
set smartindent " 智能的选择对起方式
set tabstop=2 " 设置tab键为2个空格
set shiftwidth=2 " 将换行自动缩进设置成2个空格
set hidden
set nobackup
set nowritebackup
set updatetime=300
if has("patch-8.1.1564")
	set signcolumn=number
else
	set signcolumn=yes
endif
syntax enable " 设置主题
colorscheme gruvbox
set background=dark
set cmdheight=2
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " 取消注释下换行自动插入注释符号

" 解决插入模式下delete/backspce键失效问题
set backspace=2
" 解决变为nomal模式变慢问题
set timeoutlen=1000 ttimeoutlen=0
"Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
	let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
	let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

" 插件设置
" coc
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-snippets', 'coc-css', 'coc-html', 'coc-imselect', 'coc-vimlsp', 'coc-pairs', 'coc-highlight', 'coc-explorer', 'coc-bookmark', 'coc-yank', 'coc-git']
let g:coc_user_config = "$HOME/.vim/coc-settings.json"
" coc回车事件
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
	inoremap <silent><expr> <c-space> coc#refresh()
else
	inoremap <silent><expr> <c-@> coc#refresh()
endif

if exists('*complete_info')
	inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
	inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd CursorHold,CursorHoldI * CocCommand git.refresh
augroup Binary
autocmd!
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
autocmd BufEnter * CocCommand git.refresh
augroup END
" lightline,主题gruvbox,darcula
let g:lightline = {
			\ 'colorscheme': 'gruvbox',
			\ 'tabline': {
			\ 'right': [[]]
			\ },
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\             ['cocstatus', 'git', 'readonly', 'filename', 'modified' ] ],
			\   'right':[
			\     [ 'filetype', 'fileencoding', 'lineinfo', 'percent' ],
			\     [ 'blame' ]
			\   ],
			\ },
			\ 'component_function': {
			\   'cocstatus': 'coc#status',
			\   'filename': 'LightlineFilename',
			\   'git': 'LightlineGitStatus',
			\   'blame': 'LightlineGitBlame',
			\ },
			\ }
function! LightlineFilename()
	return expand('%')
endfunction
function! LightlineGitBlame() abort
	let blame = get(b:, 'coc_git_blame', '')
	return winwidth(0) > 120 ? blame : ''
endfunction
function! LightlineGitStatus() abort
	let status = get(g:, 'coc_git_status', '')
	return winwidth(0) > 120 ? status : ''
endfunction
" nerdcommenter
let g:NERDCreateDefaultMappings = 0 " 禁用默认快捷键
let g:NERDSpaceDelims = 1 " 注释后默认添加空格
let g:NERDTrimTrailingWhitespace = 1 " 取消注释自动去除空格
let g:NERDCustomDelimiters={
			\ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
			\}
" vim-prettier
let g:prettier#quickfix_enabled = 0 " 格式化时，不显示错误警告
nmap prettier <Plug>(Prettier)
" fzf
let fzf_opt = '--layout=reverse'
let fzf_preview = 'right:60%'
let $FZF_DEFAULT_OPTS = fzf_opt
let g:fzf_preview_window = fzf_preview
let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.6, 'highlight': 'Todo', 'border': 'border' } }
let s:fzf_color_dark = ['--color', 'fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f', '--color', 'info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54']
let g:coc_fzf_opts = [fzf_opt]
let g:coc_fzf_preview = fzf_preview
" indentLine
let g:indentLine_char = '|'
let g:indentLine_conceallevel = 2
let g:indentLine_fileTypeExclude = ['coc-explorer', 'startify']
:set list lcs=tab:\|\  
" indentLine引起的json不显示""问题
let g:vim_json_syntax_conceal = 0

" 快捷键
let g:mapleader = "\<Space>" " 设置leader键为空号键
let g:maplocalleader = ','
nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>

nmap <Leader>cc <plug>NERDCommenterToggle
vmap <Leader>cc <plug>NERDCommenterToggle
nmap <Leader>cm <plug>NERDCommenterMinimal
vmap <Leader>cm <plug>NERDCommenterMinimal
nmap <Leader>cf :Autoformat<CR>
autocmd FileType javascript.jsx nmap <buffer> <Leader>cf <Plug>(Prettier)

nmap <Leader>jd <Plug>(coc-definition)
nmap <silent> <Leader>e :CocCommand explorer<CR>

nmap <Leader>ss <Plug>(easymotion-s2)
nmap <Leader>sf :Files<CR>
nmap <Leader>sw :Ag<CR>
nnoremap <Leader>su :FzfFunky<Cr>
nnoremap <Leader>sh :History<Cr>
nmap <Leader>bf :Buffers<CR>
nmap <Leader>w :Windows<CR>
nmap <Leader>y :CocFzfList yank<CR>
nmap <Leader>bl :CocFzfList bookmark<CR>
nmap <Leader>ba <Plug>(coc-bookmark-toggle)
nmap <Leader>bn <Plug>(coc-bookmark-next)
nmap <Leader>bp <Plug>(coc-bookmark-prev)
nmap <Leader>gp <Plug>(coc-git-prevchunk)
nmap <Leader>gn <Plug>(coc-git-nextchunk)
nmap <Leader>gi <Plug>(coc-git-chunkinfo)
