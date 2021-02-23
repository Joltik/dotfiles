if exists('g:loaded_pandacomplete') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

lua require('pandacomplete').pandacomplete_augroup()

function! pandacomplete#func(findstart, base)
  let CompleteFunc = luaeval('require("pandacomplete").pandacomplete_func')
  call CompleteFunc(a:findstart, a:base)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_pandacomplete = 1
