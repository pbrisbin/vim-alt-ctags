if exists("g:alt_ctags_loaded")
  finish
endif
let g:alt_ctags_loaded = 1

if !exists("g:default_ctags_command")
  let g:default_ctags_command = 'ctags -R .'
endif

function! s:RunQuietly(cmd)
  execute ':silent !'.a:cmd.' 2>/dev/null &'
endfunction

function! s:IsGitProject()
  execute "silent! !git rev-parse"
  return !v:shell_error
endfunction

function! s:RegenerateCtags()
  if !exists('b:ctags_command') && s:IsGitProject()
    let b:ctags_command = g:default_ctags_command
  endif

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
