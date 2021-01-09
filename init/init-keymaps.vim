let g:mapleader = "\<Space>"

" map
nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>fc :CocConfig<CR>

nmap <Leader>ss <Plug>(easymotion-s2)
nmap <Leader>w <Plug>(choosewin)
nmap <silent> <Leader>e :CocCommand explorer --sources=file+<CR>

nmap <Leader>sr :CocRestart<CR>

nmap <Leader>cf <Plug>(Prettier)
autocmd FileType vim nmap <buffer> <Leader>cf :Autoformat<CR>

nmap <Leader>gn <Plug>(coc-git-nextchunk)
nmap <Leader>gp <Plug>(coc-git-prevchunk)
nmap <Leader>gi <Plug>(coc-git-chunkinfo)
nmap <Leader>gs :GFiles?<CR>
nmap <Leader>gd :vert Git diff<CR>
nmap <Leader>gf :Gvdiffsplit<CR>
nmap <Leader>gu :CocCommand git.chunkUndo<CR>

map <Leader>cc <plug>NERDCommenterToggle
map <Leader>cm <plug>NERDCommenterMinimal
map <Leader>cd :RooterToggle<CR>

map <Leader>sf :Files<CR>
map <Leader>sb :Buffers<CR>
map <Leader>sh :History<CR>
map <Leader>sc :History:<CR>
nnoremap <Leader>su :Vista finder<CR>
nnoremap <silent> <Leader>sw :Rg<CR>
" nnoremap <silent> <Leader>sw :Rg <C-R><C-W><CR>
xnoremap <silent> <Leader>sw y:Rg <C-R>"<CR>

nmap <Leader>cs <Plug>CtrlSFCwordExec
vmap <Leader>cs <Plug>CtrlSFVwordExec

nmap <silent> <Leader>jd <Plug>(coc-definition)
nmap <silent> <Leader>jy <Plug>(coc-type-definition)
nmap <silent> <Leader>ji <Plug>(coc-implementation)
nmap <silent> <Leader>jr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <Leader>sd :call <SID>show_documentation()<CR>

nmap <Leader>ba <Plug>BookmarkToggle
nmap <Leader>bc <Plug>BookmarkClearAll
nmap <Leader>bl :CocCommand fzf-preview.Bookmarks<CR>

nnoremap <silent> <Leader>dl :<C-u>CocFzfList diagnostics --current-buf<CR>
nmap <silent> <Leader>dp <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>dn <Plug>(coc-diagnostic-next)

nmap <silent> <C-y> :.w !pbcopy<CR><CR>
vnoremap <silent> <C-y> :<CR>:let @a=@" \| execute "normal! vgvy" \| let res=system("pbcopy", @") \| let @"=@a<CR>
