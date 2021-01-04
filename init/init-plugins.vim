if empty(glob('~/.vim/autoload/plug.vim'))
	silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'itchyny/lightline.vim'
Plug 'easymotion/vim-easymotion'
Plug 't9md/vim-choosewin'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Joltik/fzf-funky',{'on': 'FzfFunky'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf'
Plug 'chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'scrooloose/nerdcommenter'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-startify'
Plug 'airblade/vim-rooter'
Plug 'flazz/vim-colorschemes'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'dylanngo95/react-native-snippet'
Plug 'matze/vim-move'
Plug 'simnalamburt/vim-mundo'
Plug 'justinmk/vim-gtfo'
Plug 'rhysd/git-messenger.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'tweekmonster/startuptime.vim'

call plug#end()

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
			\   'git': 'LightlineGitStatus',
			\ },
			\ }

function! LightlineGitStatus() abort
	let status = get(g:, 'coc_git_status', '')
	return winwidth(0) > 120 ? status : ''
endfunction

" vim-easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

" coc
let g:coc_config_home = '$HOME/.config/nvim'
let g:coc_global_extensions = ['coc-explorer', 'coc-tsserver', 'coc-json', 'coc-vimlsp', 'coc-pairs', 'coc-fzf-preview', 'coc-snippets', 'coc-git']
autocmd FileType * let b:coc_pairs_disabled = ['<']
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd CursorHold * :CocCommand git.refresh
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

" nerdcommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCustomDelimiters = {
			\ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
			\}

" fzf
let fzf_float_rate = 0.6
let fzf_opt = '--layout=reverse'
let $FZF_DEFAULT_OPTS = fzf_opt
let g:fzf_layout = { 'window': { 'width': fzf_float_rate, 'height': fzf_float_rate } }
let g:fzf_preview_floating_window_rate = fzf_float_rate
let g:coc_fzf_preview = 'right'
let g:coc_fzf_opts = [fzf_opt]
let g:fzf_funky_opts = [fzf_opt]

" rg
function! RipgrepFzf(query, fullscreen)
	let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
	let initial_command = printf(command_fmt, shellescape(a:query))
	let reload_command = printf(command_fmt, '{q}')
	let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
	call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

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

" move
let g:move_key_modifier = 'C'

" mundo
let g:mundo_width = 40
let g:mundo_preview_height = 30
let g:mundo_right = 1

" git-messenger
let g:git_messenger_no_default_mappings = 1
let g:git_messenger_include_diff = 'current'
let g:git_messenger_into_popup_after_show = 0

" ctrlsf
let g:ctrlsf_auto_focus = {
			\ "at": "start"
			\ }
let g:ctrlsf_default_root = 'cmd'
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_position = 'right'
let g:ctrlsf_winsize = '30%'

" vim-rooter
autocmd VimEnter * RooterToggle
