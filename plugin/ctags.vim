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

if !exists("g:ctags_excludes")
  let g:ctags_excludes = ['~']
endif

function s:RunQuietly(cmd)
  execute ":silent! !".a:cmd." &>/dev/null &"
endfunction

function s:Untracked()
  execute ":silent! !git ls-files '%' --error-unmatch &>/dev/null"
  return v:shell_error
endfunction

function s:Excluded()
  let cur = fnamemodify(getcwd(), ':p')

  for exclude in g:ctags_excludes
    if cur == fnamemodify(exclude, ':p')
      return 1
    endif
  endfor

  return 0
endfunction

function s:RegenerateCtags()
  if s:Excluded()
    return
  endif

  " avoid git check if a tags file is already present
  if !filereadable(g:ctags_file) && s:Untracked()
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
