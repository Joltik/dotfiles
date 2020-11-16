call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Joltik/fzf-funky',{'on': 'FzfFunky'}
Plug 'Yggdroot/indentLine'
Plug 'elzr/vim-json'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'prettier/vim-prettier', {'do': 'yarn install','for': ['javascript', 'typescript'] }
Plug 'chiel92/vim-autoformat'
Plug 't9md/vim-choosewin'
Plug 'scrooloose/nerdcommenter'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'honza/vim-snippets'
Plug 'airblade/vim-rooter'
Plug 'glepnir/dashboard-nvim'

call plug#end()


" 系统设置
set number
set cursorline
set hlsearch
set splitright
set clipboard=unnamed
set laststatus=2
set showtabline=2
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set nobackup
set nowritebackup
set updatetime=300

syntax enable
colorscheme gruvbox
set background=dark
set cmdheight=2

if (has("nvim"))
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
	set termguicolors
endif

" 取消注释下换行自动插入注释符号
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" 插件设置
" 离开插入模式后强制切换为默认输入法
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


" fzf
let fzf_float_rate = 0.6
let fzf_opt = '--layout=reverse'
let fzf_preview = 'right:60%'
let $FZF_DEFAULT_OPTS = fzf_opt
let g:fzf_preview_window = fzf_preview
let g:fzf_layout = { 'window': { 'width': fzf_float_rate, 'height': fzf_float_rate } }
let s:fzf_color_dark = ['--color', 'fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f', '--color', 'info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54']
" fzf-funky
let g:coc_fzf_opts = [fzf_opt]
let g:coc_fzf_preview = fzf_preview
" fzf_preview_window
let g:fzf_preview_floating_window_rate = fzf_float_rate

" Ag显示文件名设置，不会预览文件
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

" RG搜索显示文件名，搜索准确性高于Ag
function! RipgrepFzf(query, fullscreen)
	let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
	let initial_command = printf(command_fmt, shellescape(a:query))
	let reload_command = printf(command_fmt, '{q}')
	let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
	call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)


" indentLine
let g:indentLine_conceallevel = 2
let g:indentLine_fileTypeExclude = ['coc-explorer', 'dashboard']
:set list lcs=tab:\|\  " indentLine显示异常问题
" indentLine引起的json不显示""问题
let g:vim_json_syntax_conceal = 0


" coc
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-css', 'coc-html', 'coc-vimlsp', 'coc-pairs', 'coc-explorer', 'coc-git', 'coc-snippets', 'coc-highlight', 'coc-fzf-preview', 'coc-dictionary', 'coc-floatinput']


autocmd FileType * let b:coc_pairs_disabled = ['<']
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd CursorHold,CursorHoldI * CocCommand git.refresh
" autocmd InsertLeave * call coc#float#close_all()
" 高亮单词颜色
" hi CocHighlightText ctermfg=black ctermbg=72 guifg=white guibg=#FF4500
" hi CoCHoverRange ctermfg=black ctermbg=72 guifg=white guibg=#FF4500

augroup Binary
	autocmd!
	autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif
	autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
	autocmd BufEnter * CocCommand git.refresh
augroup END

" coc-dictionary
set dictionary=$HOME/.config/nvim/words


" vim-prettier
let g:prettier#quickfix_enabled = 0


" nerdcommenter
let g:NERDCreateDefaultMappings = 0 " 禁用默认快捷键
let g:NERDSpaceDelims = 1 " 注释后默认添加空格
let g:NERDTrimTrailingWhitespace = 1 " 取消注释自动去除空格
let g:NERDCustomDelimiters={
			\ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
			\}


" vim-bookmarks
let g:bookmark_no_default_key_mappings = 1


" Default value is clap
let g:dashboard_default_executive = 'fzf'
let g:dashboard_default_header = 'evil'
let g:dashboard_fzf_float = fzf_float_rate
autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2


" 快捷键
let g:mapleader = "\<Space>"
nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>fc :CocConfig<CR>

nmap <Leader>ss <Plug>(easymotion-s2)
nmap <Leader>sf :Files<CR>
nmap <Leader>sw :RG<CR>
nnoremap <Leader>su :FzfFunky<Cr>
nnoremap <Leader>sh :History<Cr>
nmap <Leader>sb :Buffers<CR>
nnoremap <Leader>sl :CocCommand fzf-preview.Lines<Cr>
nmap <Leader>bl :CocCommand fzf-preview.Bookmarks<CR>


nmap <Leader>w <Plug>(choosewin)
nmap <Leader>jd <Plug>(coc-definition)
nmap <silent> <Leader>e :CocCommand explorer --sources=file+<CR>

nmap <Leader>cf :Autoformat<CR>
autocmd FileType javascript.jsx nmap <buffer> <Leader>cf <Plug>(Prettier)

nmap <Leader>cc <plug>NERDCommenterToggle
vmap <Leader>cc <plug>NERDCommenterToggle
nmap <Leader>cm <plug>NERDCommenterMinimal
vmap <Leader>cm <plug>NERDCommenterMinimal

nmap <Leader>gp <Plug>(coc-git-prevchunk)
nmap <Leader>gn <Plug>(coc-git-nextchunk)
nmap <Leader>gi <Plug>(coc-git-chunkinfo)

nmap <Leader>ba <Plug>BookmarkToggle
nmap <Leader>bc <Plug>BookmarkClearAll

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)


nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>
