" lua require('plugins')
call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'airblade/vim-gitgutter'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'easymotion/vim-easymotion'
Plug 'tweekmonster/startuptime.vim'
Plug 'chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/completion-nvim'

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

if (has("termguicolors"))
  set termguicolors
endif

set rtp+=/Users/xiaogao/.config/nvim/plugin/*.vim

lua require('plugin_setting')

" rg
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" autocmd
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \  exe "normal! g`\"" |
      \ endif
autocmd FileType * let b:coc_pairs_disabled = ['<']
" plug setting
let g:completion_timer_cycle = 10
let g:plug_window = 'vertical rightbelow new'
" vim-easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
" gitgutter
let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_modified = '▌'
let g:gitgutter_sign_removed = '▌'
let g:gitgutter_sign_removed_first_line = '▌'
let g:gitgutter_sign_removed_above_and_below = '▌'
let g:gitgutter_sign_modified_removed = '▌'
" nerdcommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCustomDelimiters = {
      \ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
      \}
" vim-prettier
let g:prettier#quickfix_enabled = 0
" fzf
let $FZF_DEFAULT_OPTS = '--layout=reverse'
let g:fzf_layout = { 'window': { 'width': 0.75, 'height': 0.6} }
" coc
let g:coc_config_home = '$HOME/.config/nvim'
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-vimlsp', 'coc-pairs', 'coc-flutter']

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

nmap <silent><Leader>jd <Plug>(coc-definition)
nmap <leader>rn <Plug>(coc-rename)

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
