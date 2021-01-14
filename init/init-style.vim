" 总是显示状态栏
set laststatus=2

" 高亮光标所在的行
set cursorline

" 总是显示行号
set number

" 自动显示侧边栏（用于显示 mark/gitdiff/诊断信息）
set signcolumn=auto

" 水平切割窗口时，默认在右边显示新窗口
set splitright

" 填充分割线字符
set fillchars=vert:¦
" set fillchars=vert:\  " vsplit line char

" 据底部10行
set scrolloff=10

" 允许 256 色
set t_Co=256

" 真彩色
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

colorscheme vim-monokai-tasty
set background=dark


hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guifg=#455a64 guibg=NONE ctermfg=239 ctermbg=NONE
hi CocHighlightText guibg=#e57373 guifg=#eceff1 ctermbg=167 ctermfg=229

hi link GitGutterAdd colorsboxGreen
hi link GitGutterChange colorsboxYellow
hi link GitGutterDelete colorsboxRed
hi link GitGutterChangeDelete colorsboxBlue
hi link CocExplorerOmitSymbol colorsboxFg1
hi link CocHighlightRead CocHighlightText
hi link CocHighlightWrite CocHighlightText

let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#455a64'
