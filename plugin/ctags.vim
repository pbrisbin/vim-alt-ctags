function! Ctags()
  if exists('b:ctags_command')
    " vim lets you define multiple tags files. this doesn't work for us.
    " we want to know an exact file so we can actively remove it.
    if !exists('b:ctags_file')
      let b:ctags_file = 'tags'
    endif

    try
      execute ':silent !rm -f '.b:ctags_file.'; '.b:ctags_command.' 2>/dev/null &'
    catch
      " ignore any errors
    endtry
  endif
endfunction

command! Ctags call Ctags()
autocmd BufEnter * call Ctags()
