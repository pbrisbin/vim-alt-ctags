if exists("g:alt_ctags_loaded")
  finish
endif
let g:alt_ctags_loaded = 1

if !exists("g:ctags_command")
  let g:ctags_command = "ctags -f '%f' -R"
endif

if !exists("g:ctags_file")
  let g:ctags_file = 'tags'
endif

function s:RunQuietly(cmd)
  execute ":silent !".a:cmd." &>/dev/null &"
endfunction

function s:IsGitControlled(file)
  execute ":silent! !git ls-files '".a:file."' --error-unmatch &>/dev/null"
  return !v:shell_error
endfunction

function s:RegenerateCtags()
  if !s:IsGitControlled(expand('%'))
    return
  endif

  if !exists('b:ctags_command')
    let b:ctags_command = g:ctags_command
  endif

  let tempfile = g:ctags_file.'.temp'
  let ctags_command = substitute(b:ctags_command, '%f', tempfile, '')

  try
    call s:RunQuietly(ctags_command)
    call s:RunQuietly("mv '".tempfile."' '".g:ctags_file."'")
  catch
    " ignore any errors
  endtry
endfunction

command Ctags call s:RegenerateCtags()
autocmd BufEnter * call s:RegenerateCtags()
