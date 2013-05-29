if exists("g:alt_ctags_loaded")
  finish
endif
let g:alt_ctags_loaded = 1

function! s:RunQuietly(cmd)
  execute ':silent !'.a:cmd.' 2>/dev/null &'
endfunction

function! s:RegenerateCtags()
  if exists('b:ctags_command')
    if !exists('b:ctags_file')
      let b:ctags_file = 'tags'
    endif

    let l:tmpfile = b:ctags_file.'.temp'

    try
      call s:RunQuietly(b:ctags_command.' -f '.l:tmpfile)
      call s:RunQuietly('mv '.l:tmpfile.' '.b:ctags_file)
    catch
      " ignore any errors
    endtry
  endif
endfunction

command! Ctags call s:RegenerateCtags()
autocmd BufEnter * call s:RegenerateCtags()
