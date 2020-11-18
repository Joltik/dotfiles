call plug#begin('~/.vim/plugged')

Plug 'joshdick/onedark.vim'
"  improved syntax highlighting
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 'glepnir/dashboard-nvim'
Plug 't9md/vim-choosewin'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

call plug#end()


" hightlighting
" not compatible vi
set nocompatible
" show line number
set number
set cursorline
set scrolloff=10


" Note: All options should be set before the colorscheme onedark line in your ~/.vimrc.
" Set to 1 if you want to hide end-of-buffer filler lines (~) for a cleaner look; 0 otherwise (the default).
let g:onedark_hide_endofbuffer=1

" theme
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on
colorscheme onedark

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


autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif


" lightline
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }



set list lcs=tab:\|\  " indentLine 
let g:indentLine_fileTypeExclude = ['dashboard']


" vim-easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1


" dashboard-nvim
let g:dashboard_default_header='commicgirl9'
let g:dashboard_custom_section={
  \ 'buffer_list': {
      \ 'description': [' Recently lase session                 SPC b b'],
      \ 'command': 'Some Command' }
  \ }


" nerdtree
let NERDTreeMinimalUI=1
let g:NERDTreeChDirMode = 2
let g:NERDTreeDirArrowExpandable = ' '
let g:NERDTreeDirArrowCollapsible = ' '
highlight NERDTreeDir guifg=#D19A66 ctermfg=red
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" open NERDTree automatically when vim starts up on opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif


" make sure vim does not open files and other buffers on NerdTree window
" If more than one window and previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
" If you are using vim-plug, you'll also need to add these lines to avoid crashes when calling vim-plug functions while the cursor is on the NERDTree window
let g:plug_window = 'noautocmd vertical topleft new'

let g:mapleader = "\<Space>"

nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
nmap <Leader>s <Plug>(easymotion-overwin-f2)
nmap <Leader>w <Plug>(choosewin)
map <Leader>e :NERDTreeToggle<CR>


