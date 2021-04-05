if exists('g:loaded_pandatree') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

hi def link PandaTreeRoot Number
hi def link PandaTreeFolder Directory
hi def link PandaTreeFile Normal
hi def link PandaTreeGitStaged Number
hi def link PandaTreeGitDirty Directory

command! Pandatree lua require'panda.pandatree'.togger_tree()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_pandatree = 1
