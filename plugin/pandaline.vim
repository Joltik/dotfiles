if exists('g:loaded_pandaline') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

hi statusline guibg=NONE ctermbg=NONE
hi PandaViMode guifg=#282c34
hi PandaFile guibg=#38393f ctermbg=NONE guifg=#eeeeee ctermfg=15
hi PandaGit guibg=#38393f ctermbg=NONE guifg=#eeeeee ctermfg=15
hi PandaFill guibg=#38393f ctermbg=NONE
hi PandaDim guibg=#5c6370 ctermbg=NONE guifg=#2c323d ctermfg=15
hi PandaLinePercent guibg=#61afef ctermbg=NONE guifg=#2c323d ctermfg=15
hi def link PandaTablineExplorer Number
hi PandaTablineNomal guibg=#5c6370 ctermbg=NONE guifg=#2c323d ctermfg=15
hi PandaTablineSelected guibg=#61afef ctermbg=NONE guifg=#2c323d ctermfg=15
hi PandaTablineFill guibg=NONE ctermbg=NONE

lua require('pandaline').pandaline_augroup()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_pandaline = 1
