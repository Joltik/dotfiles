call plug#begin('~/.vim/plugged')

Plug 'yianwillis/vimcdoc'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'chiel92/vim-autoformat'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 't9md/vim-choosewin'
Plug 'airblade/vim-rooter'
Plug 'mhinz/vim-startify'
Plug 'tweekmonster/startuptime.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'glepnir/galaxyline.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

call plug#end()

set hlsearch
set incsearch
set scrolloff=5
set updatetime=300
set shortmess+=c
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

set completeopt=menuone,noinsert
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

lua require('plug_setting')

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
" gitgutter
let g:gitgutter_map_keys = 0
" coc
let g:coc_config_home = '$HOME/.config/nvim'
let g:coc_global_extensions = ['coc-explorer', 'coc-tsserver', 'coc-json', 'coc-vimlsp', 'coc-pairs', 'coc-snippets', 'coc-tabnine']
let g:coc_snippet_next = '<tab>'
" fzf
let $FZF_DEFAULT_OPTS = '--layout=reverse'
let g:fzf_layout = { 'window': { 'width': 0.6, 'height': 0.6} }

" autocmd
" augroup lazy_load
" autocmd!
" autocmd VimEnter *
" \ call plug#load('coc.nvim') |
" \ autocmd! lazy_load
" augroup END
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \  exe "normal! g`\"" |
      \ endif
autocmd BufEnter,FocusGained,InsertLeave * call IM_SelectDefault()
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
autocmd FileType * let b:coc_pairs_disabled = ['<']
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

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! DisExpHorCursorMove()
  if &filetype == 'coc-explorer'
    call cursor(line('.'), 1)
  endif
endfunction

" rg
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

" keymaps
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
" \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" inoremap <silent><expr> <TAB>
" \ pumvisible() ? coc#_select_confirm() :
" \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
" \ <SID>check_back_space() ? "\<TAB>" :
" \ coc#refresh()

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

nmap <silent> <Leader>e :CocCommand explorer --sources=file+<CR>
nmap <Leader>w <Plug>(choosewin)

nnoremap <silent> <Leader>bn :BufferLineCycleNext<CR>
nnoremap <silent> <Leader>bp :BufferLineCyclePrev<CR>
nnoremap <silent> <Leader>bc :BufferLinePick<CR>
nnoremap <silent> <Leader>bm :BufferLineMovePrev<CR>
nnoremap <silent> <Leader>bd :bd<CR>

map <Leader>cc <plug>NERDCommenterToggle
map <Leader>cm <plug>NERDCommenterMinimal
nmap <Leader>cf <Plug>(Prettier)
autocmd FileType vim,lua nmap <buffer> <Leader>cf :Autoformat<CR>

nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>fc :vne<CR>:CocConfig<CR>

nmap <Leader>gn <Plug>(GitGutterNextHunk)
nmap <Leader>gp <Plug>(GitGutterPrevHunk)
nmap <Leader>gi <Plug>(GitGutterPreviewHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)

" nmap <silent> jd <Plug>(coc-definition)
nmap <silent> <Leader>jd <Cmd>lua vim.lsp.buf.definition()<CR>

nmap <leader>rn <Plug>(coc-rename)

nmap <Leader>ss <Plug>(easymotion-s2)
nnoremap <silent> <leader>st :vne<CR>:StartupTime<CR>

" map <silent> <Leader>sf :Files<CR>
" map <silent> <Leader>sb :Buffers<CR>
" map <silent> <Leader>sh :History<CR>
" map <silent> <Leader>sc :History:<CR>
" map <silent> <Leader>sg :GFiles?<CR>
" nnoremap <silent> <Leader>sw :Rg<CR>
" xnoremap <silent> <Leader>sw y:Rg <C-R>"<CR>
nnoremap <leader>sf <cmd>Telescope find_files<cr>
nnoremap <leader>sb <cmd>Telescope buffers<cr>
nnoremap <leader>sw <cmd>Telescope live_grep<cr>
nnoremap <Leader>sg :lua require'telescope.builtin'.git_files{}<CR>

