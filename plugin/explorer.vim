if exists('g:loaded_explorer') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

hi def link ExplorerRoot Number
hi def link ExplorerFolder Directory
hi def link ExplorerFile Normal
hi AlertOptionSelect guibg=#ff0000 ctermbg=249 guifg=#ffffff ctermfg=15
hi FloatWinBg guibg=#808080 ctermbg=8 guifg=#ffffff ctermfg=15
hi def link ExplorerGitStaged Number
hi def link ExplorerGitDirty Directory

command! Explorer lua require'explorer'.togger_explorer()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_explorer = 1
