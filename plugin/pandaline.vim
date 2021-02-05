if exists('g:loaded_pandaline') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

hi statusline guibg=NONE ctermbg=NONE
hi PandaFile guibg=#38393f ctermbg=NONE guifg=#eeeeee ctermfg=15
hi PandaSpace guibg=#38393f ctermbg=NONE

lua require('pandaline').pandaline_augroup()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_pandaline = 1
