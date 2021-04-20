call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'easymotion/vim-easymotion'
Plug 'tweekmonster/startuptime.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

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

set rtp+=/Users/xiaogao/.config/nvim/plugin/*.vim

lua require('config')

" autocmd
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \  exe "normal! g`\"" |
      \ endif

" rg
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" plug setting
let g:completion_timer_cycle = 10
let g:plug_window = 'vertical rightbelow new'
" vim-easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
" fzf
let $FZF_DEFAULT_OPTS = '--layout=reverse'
let g:fzf_layout = { 'window': { 'width': 0.75, 'height': 0.6} }
" nerdcommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCustomDelimiters = {
      \ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
      \}
" gitgutter
let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_modified = '▌'
let g:gitgutter_sign_removed = '▌'
let g:gitgutter_sign_removed_first_line = '▌'
let g:gitgutter_sign_removed_above_and_below = '▌'
let g:gitgutter_sign_modified_removed = '▌'
" vim-prettier
let g:prettier#quickfix_enabled = 0
" coc
let g:coc_config_home = '$HOME/.config/nvim'
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-vimlsp', 'coc-pairs', 'coc-flutter']
autocmd FileType * let b:coc_pairs_disabled = ['<']

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" keymaps
let g:mapleader = "\<Space>"

nmap <silent> <Leader>e :Pandatree<CR>
nmap <silent> <Leader>w :Pandawin<CR>

nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>

nmap <Leader>gn <Plug>(GitGutterNextHunk)
nmap <Leader>gp <Plug>(GitGutterPrevHunk)
nmap <Leader>gi <Plug>(GitGutterPreviewHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)

nmap <Leader>ss <Plug>(easymotion-s2)
nnoremap <silent> <leader>st :vne<CR>:StartupTime<CR>

map <Leader>cc <plug>NERDCommenterToggle
map <Leader>cm <plug>NERDCommenterMinimal
nmap <Leader>cf <Plug>(Prettier)
autocmd FileType vim,lua nmap <buffer> <Leader>cf :Autoformat<CR>

map <silent> <Leader>sf :Files<CR>
map <silent> <Leader>sb :Buffers<CR>
map <silent> <Leader>sh :History<CR>
map <silent> <Leader>sc :History:<CR>
map <silent> <Leader>sg :GFiles?<CR>
nnoremap <silent> <Leader>sw :Rg<CR>
xnoremap <silent> <Leader>sw y:Rg <C-R>"<CR>
