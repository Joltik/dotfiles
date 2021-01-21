if exists('g:loaded_explorer') | finish | endif

let s:save_cpo = &cpo
set cpo&vim 

command! Explorer lua require'explorer'.togger_explorer()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_explorer = 1
