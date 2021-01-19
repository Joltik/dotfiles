call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
Plug 'tweekmonster/startuptime.vim'
" lsp
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/completion-treesitter'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
" code
Plug 'windwp/nvim-autopairs'
Plug 'chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'scrooloose/nerdcommenter'
" beautify
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'Joltik/nvim-tree.lua'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'norcalli/nvim-colorizer.lua'
" function
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-rooter'
Plug 't9md/vim-choosewin'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

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
set signcolumn=auto
set splitright
set fillchars=vert:¦

" fold
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" theme
let g:nvcode_termcolors=256

syntax on
colorscheme onedark
set background=dark

if (has("termguicolors"))
  set termguicolors
endif

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE guifg=#455a64 ctermbg=NONE ctermfg=239
hi EndOfBuffer guibg=NONE guifg=#282c34 ctermbg=NONE ctermfg=249
hi StatusLine guibg=NONE ctermbg=NONE
" plug
hi link NvimTreeRootFolder Directory
hi link NvimTreeFolderIcon Directory
hi link NvimTreeGitDeleted diffRemoved
hi link NvimTreeGitDirty diffRemoved
hi link NvimTreeGitRenamed diffNewFile

hi DiffAdd guifg=#98c379 ctermfg=114 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiffChange guifg=#e5c07b ctermfg=180 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiffDelete guifg=#e06c75 ctermfg=168 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

lua require('plug')

" autocmd
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \  exe "normal! g`\"" |
      \ endif
autocmd BufEnter,FocusGained,InsertLeave * call IM_SelectDefault()
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'NvimTree') | q | endif
autocmd CursorMoved * call DisExpHorCursorMove()

" function
let g:im_default = 'com.apple.keylayout.ABC'
function! IM_SelectDefault()
  let b:saved_im = system("im-select")
  if v:shell_error
    unlet b:saved_im
  else
    let l:a = system("im-select " . g:im_default)
  endif
endfunction

function! VisualStarSearchSet(cmdtype,...)
  let temp = @"
  normal! gvy
  if !a:0 || a:1 != 'raw'
    let @" = escape(@", a:cmdtype.'\*')
  endif
  let @/ = substitute(@", '\n', '\\n', 'g')
  let @/ = substitute(@/, '\[', '\\[', 'g')
  let @/ = substitute(@/, '\~', '\\~', 'g')
  let @/ = substitute(@/, '\.', '\\.', 'g')
  let @" = temp
endfunction

function! DisExpHorCursorMove()
  if &filetype == 'NvimTree'
    call cursor(line('.'), 1)
  endif
endfunction

" plug setting
let g:plug_window = 'vertical rightbelow new'
" vim-easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
" nerdcommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCustomDelimiters = {
      \ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
      \}
" vim-prettier
let g:prettier#quickfix_enabled = 0
" nvim-tree
let g:nvim_tree_show_icons = {
      \ 'git': 0,
      \ 'folders': 1,
      \ 'files': 1,
      \ }
" completed
let g:completion_matching_ignore_case = 0
let g:completion_matching_smart_case = 0
let g:completion_timer_cycle = 5

" keymaps
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

xnoremap * :<C-u>call VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>

nnoremap <silent> <C-k>  :<c-u>execute 'move -1-'. v:count1<CR>
nnoremap <silent> <C-j>  :<c-u>execute 'move +'. v:count1<CR>

nnoremap -<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap +<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

nmap <C-y> "*yw
xmap <C-y> "*y

let g:mapleader = "\<Space>"

nnoremap <silent> <Leader>e :NvimTreeToggle<CR>
nmap <Leader>w <Plug>(choosewin)

map <Leader>cc <plug>NERDCommenterToggle
map <Leader>cm <plug>NERDCommenterMinimal
nmap <Leader>cf <Plug>(Prettier)
autocmd FileType vim,lua nmap <buffer> <Leader>cf :Autoformat<CR>

nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>

nmap <Leader>gn <cmd>lua require"gitsigns".next_hunk()<CR>
nmap <Leader>gp <cmd>lua require"gitsigns".prev_hunk()<CR>
nmap <Leader>gi <cmd>lua require"gitsigns".preview_hunk()<CR>
nmap <Leader>gu <cmd>lua require"gitsigns".reset_hunk()<CR>

nnoremap <silent> <Leader>jd <cmd>lua vim.lsp.buf.definition()<CR>

nmap <Leader>ss <Plug>(easymotion-s2)
nnoremap <silent> <leader>st :vne<CR>:StartupTime<CR>
