if exists('g:loaded_pandawin') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

hi PandaWinMid guibg=#61afef guifg=#2c323d
hi PandaWinFill guibg=#38393f

command! Pandawin lua require'panda.pandawin'.show()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_pandawin = 1
