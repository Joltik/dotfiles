if exists('g:loaded_pandatree') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! Pandatree lua require'pandatree'.togger_tree()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_pandatree = 1
