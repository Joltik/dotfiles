set hlsearch
set incsearch
set scrolloff=5
set updatetime=300
set shortmess+=c
set nobackup
set nowritebackup
set hidden
" tabsize
set expandtab
set shiftwidth=2
set tabstop=2
" style
set noshowmode
set laststatus=2
set number
set cursorline
set signcolumn=auto
set splitright
set fillchars=vert:¦
set wrap
set showtabline=1
set completeopt=menuone,noinsert

syntax on
colorscheme onedark
set termguicolors

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE guifg=#455a64 ctermfg=239
hi EndOfBuffer guibg=NONE ctermbg=NONE guifg=#282c34 ctermfg=249
