" 禁止备份
set nobackup

" 禁止保存备份
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" 禁用交换文件
set noswapfile

" 禁用 undo文件
set noundofile

" 打开自动换行
set wrap

" startify
if (!has("nvim"))
  set viminfo='100,n$HOME/.vim/viminfo
endif

" 打开文件时恢复上一次光标所在位置
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \  exe "normal! g`\"" |
      \ endif

" 换行取消继续注释
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" 从右侧打开help文件
autocmd BufEnter * if &ft ==# 'help' | wincmd L | endif

" reset chinese input
let g:im_default = 'com.apple.keylayout.ABC'
autocmd BufEnter,FocusGained,InsertLeave * call IM_SelectDefault()
function! IM_SelectDefault()
  let b:saved_im = system("im-select")
  if v:shell_error
    unlet b:saved_im
  else
    let l:a = system("im-select " . g:im_default)
  endif
endfunction

