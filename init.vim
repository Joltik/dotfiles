call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
Plug 'tweekmonster/startuptime.vim'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/completion-treesitter'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'windwp/nvim-autopairs'

call plug#end()

set hlsearch
set incsearch
set scrolloff=5
set updatetime=300
set shortmess+=c
set completeopt=menuone,noinsert
set nobackup
set nowritebackup
" tabsize
set expandtab
set shiftwidth=2
set tabstop=2
" style
set laststatus=2
set number
set cursorline
set signcolumn=number
set splitright
set fillchars=vert:¦

" fold
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

let g:nvcode_termcolors=256

syntax on
colorscheme onedark
set background=dark

if (has("termguicolors"))
  set termguicolors
endif

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE guifg=#455a64 ctermfg=239
hi EndOfBuffer guibg=NONE ctermbg=NONE guifg=#282c34 ctermfg=249

lua require('lsp')
lua require('plug')

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:completion_matching_ignore_case = 0
let g:completion_matching_smart_case = 0
let g:completion_timer_cycle = 5
let g:completion_chain_complete_list = {
			\'default' : {
			\	'default' : [
			\		{'complete_items' : ['lsp', 'snippet']},
			\		{'mode' : 'file'}
			\	],
			\	'comment' : [],
			\	'string' : []
			\	},
			\'vim' : [
			\	{'complete_items': ['snippet']},
			\	{'mode' : 'cmd'}
			\	],
			\'c' : [
			\	{'complete_items': ['ts']}
			\	],
			\'python' : [
			\	{'complete_items': ['ts']}
			\	],
			\'lua' : [
			\	{'complete_items': ['ts']}
			\	],
			\}

let g:mapleader = "\<Space>"

nnoremap <silent> <leader>st :vne<CR>:StartupTime<CR>

nnoremap <silent> <Leader>jd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <Leader>cf <cmd>lua vim.lsp.buf.formatting_sync()<CR>
