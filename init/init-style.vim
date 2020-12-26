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

colorscheme colorsbox-material
set background=dark

hi Normal guibg=NONE
hi SignColumn guibg=NONE
hi VertSplit guifg=#3e3e3e guibg=NONE

hi GitGutterAdd    guifg=#59C369
hi GitGutterChange guifg=#FFF24A
hi GitGutterDelete guifg=#E24F59
hi CocExplorerOmitSymbol guifg=#D1D5D6

let g:indentLine_color_gui = '#3e3e3e'

" colorizer
lua require'colorizer'.setup(
      \ {'*';},
      \ {
      \   RGB      = true;
      \   RRGGBB   = true;
      \   names    = true;
      \   RRGGBBAA = true;
      \ })


