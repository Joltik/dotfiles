if exists('g:loaded_pandaline') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

hi Statusline guibg=NONE ctermbg=NONE
hi PandaLineViMode guifg=#282c34
hi PandaLineFile guibg=#38393f ctermbg=NONE guifg=#eeeeee ctermfg=15
hi PandaLineGit guibg=#38393f ctermbg=NONE guifg=#eeeeee ctermfg=15
hi PandaLineFill guibg=#38393f ctermbg=NONE
hi PandaLineDim guibg=#5c6370 ctermbg=NONE guifg=#2c323d ctermfg=15
hi PandaLinePercent guibg=#61afef ctermbg=NONE guifg=#2c323d ctermfg=15
hi def link PandaTabLineExplorer Number
hi PandaTabLineNomal guibg=#5c6370 ctermbg=NONE guifg=#2c323d ctermfg=15
hi PandaTabLineSelected guibg=#61afef ctermbg=NONE guifg=#2c323d ctermfg=15
hi PandaTabLineFill guibg=NONE ctermbg=NONE

lua require('pandaline').pandaline_augroup()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_pandaline = 1
