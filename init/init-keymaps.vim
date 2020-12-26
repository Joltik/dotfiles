let g:mapleader = "\<Space>"

" map
nnoremap <silent> <leader>fd :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>fc :CocConfig<CR>

nmap <Leader>ss <Plug>(easymotion-s2)
nmap <Leader>w <Plug>(choosewin)
nmap <silent> <Leader>e :CocCommand explorer --sources=file+<CR>

nmap <Leader>cf :Autoformat<CR>
autocmd FileType javascript,typescript nmap <buffer> <Leader>cf <Plug>(Prettier)

nmap <Leader>gn <Plug>(GitGutterNextHunk)
nmap <Leader>gp <Plug>(GitGutterPrevHunk)
nmap <Leader>gi <Plug>(GitGutterPreviewHunk)
nmap <Leader>gs :GFiles?<CR>
nmap <Leader>gd :vert Git diff<CR>
nmap <Leader>gf :Gvdiffsplit<CR>
nmap <Leader>gu <Plug>(GitGutterUndoHunk)

map <Leader>cc <plug>NERDCommenterToggle
map <Leader>cm <plug>NERDCommenterMinimal

map <Leader>sf :Files<CR>
map <Leader>sb :Buffers<CR>
map <Leader>sw :Rg<CR>
map <Leader>sh :History<CR>
map <Leader>sc :History:<CR>
nnoremap <Leader>su :FzfFunky<CR>

nmap <silent> <Leader>jd <Plug>(coc-definition)
nmap <silent> <Leader>jy <Plug>(coc-type-definition)
nmap <silent> <Leader>ji <Plug>(coc-implementation)
nmap <silent> <Leader>jr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <Leader>sd :call <SID>show_documentation()<CR>

nmap <Leader>ba <Plug>BookmarkToggle
nmap <Leader>bc <Plug>BookmarkClearAll
nmap <Leader>bl :CocCommand fzf-preview.Bookmarks<CR>

nmap <silent> <C-y> :.w !pbcopy<CR><CR>
vnoremap <silent> <C-y> :<CR>:let @a=@" \| execute "normal! vgvy" \| let res=system("pbcopy", @") \| let @"=@a<CR>

" rg
function! RipgrepFzf(query, fullscreen)
      let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
      let initial_command = printf(command_fmt, shellescape(a:query))
      let reload_command = printf(command_fmt, '{q}')
      let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
      call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

