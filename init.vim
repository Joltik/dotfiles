call plug#begin('~/.vim/plugged')

" 主题
Plug 'joshdick/onedark.vim'
" 语法高亮
Plug 'sheerun/vim-polyglot'
" 状态栏
Plug 'itchyny/lightline.vim'

call plug#end()


" 语法高亮
" 设置不兼容vi
set nocompatible


" Note: All options should be set before the colorscheme onedark line in your ~/.vimrc.
" Set to 1 if you want to hide end-of-buffer filler lines (~) for a cleaner look; 0 otherwise (the default).
let g:onedark_hide_endofbuffer=1

" 主题
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



let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }
