if exists('g:loaded_im_select') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

autocmd BufEnter,FocusGained,InsertLeave * call IM_SelectDefault()

let g:im_default = 'com.apple.keylayout.ABC'
function! IM_SelectDefault()
  let b:saved_im = system("im-select")
  if v:shell_error
    unlet b:saved_im
  else
    let l:a = system("im-select " . g:im_default)
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_im_select = 1
