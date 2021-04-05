if exists('g:loaded_keymap_increase') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

xnoremap * :<C-u>call VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>

nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

nmap <C-y> "*yw
xmap <C-y> "*y

nnoremap <silent> <C-k>  :<c-u>execute 'move -1-'. v:count1<CR>
nnoremap <silent> <C-j>  :<c-u>execute 'move +'. v:count1<CR>

nnoremap -<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap +<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

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

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_keymap_increase = 1
