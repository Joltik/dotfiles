if exists('g:loaded_pandaline') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

hi NomalStatusline guibg=NONE ctermbg=NONE guifg=#767676 ctermfg=243
hi EmptyStatusline guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=15
hi PandaFile guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=15
hi PandaOther guibg=#ff0000 ctermbg=NONE guifg=#ffffff ctermfg=15

lua require('pandaline').pandaline_augroup()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_pandaline = 1
