" Wrap lines in quickfix so test output is readable
augroup WrapLineInQuickFix
  autocmd!
  autocmd FileType qf setlocal wrap
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quickfix list management (modified from Gary Bernhardt's dotfiles)
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! BufferIsOpen(bufname)
  let buflist = GetBufferList()
  for bufnum in map(
    \filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'),
    \'str2nr(matchstr(v:val, "\\d\\+"))'
    \)
    if bufwinnr(bufnum) != -1
      return 1
    endif
  endfor
  return 0
endfunction

function! ToggleQuickfixList()
  if BufferIsOpen("Quickfix List")
    cclose
  else
    copen
  endif
endfunction

function! ToggleLocationList()
  if BufferIsOpen("Location List")
    lclose
  else
    Errors
  endif
endfunction
