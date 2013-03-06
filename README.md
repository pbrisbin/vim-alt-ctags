# Alt Ctags

An alternative ctags plugin for vim.

## Installation

1. Use pathogen
2. Clone to `~/.vim/bundle/alt-ctags`

## Ctags()

The plugin exposes one function: `Ctags()`.

The function can be invoked manually via the `Ctags` command, but that's 
not the intended usage. In stead, the function is automatically added as 
an `autocmd` and run when entering any buffer. This ensures your tags 
file is always as up to date as possible.

The function `rm -f`s your `b:ctags_file` and runs `b:ctags_command` 
which, presumably, rebuilds it.

The action is silent and asynchronous. Any errors (vim or shell) are 
completely ignored, so running this command constantly and automatically 
shouldn't cause much trouble. That said, you'll get no indication if 
something's not working (aside from an out of date or missing tags 
file).

## Settings

`b:ctags_file` is the file path which alt-ctags will remove before 
running your ctags command to recreate it.

For this to be useful, that file will need to be included in the `tags` 
setting in vim proper. Luckily alt-ctags defaults this value to "tags" 
which is included in vim's default of "./tags,tags", so it should Just 
Work.

`b:ctags_command` is the command that will be run to rebuild your ctags 
file. If you do not set a `b:ctags_command`, this plugin does nothing. 
This is a safer default since `ctags -R .` could simply churn forever if 
it were kicked off in the wrong directory.

For this reason, It's **very important** that you only set a 
`b:ctags_command` from a filetype hook **and** only after you've done 
some check to ensure you're in a project directory where building a tags 
file is appropriate and feasible.

Here's what I use for ruby:

**~/.vim/ftplugin/ruby.vim**

~~~ { .vim }
if isdirectory('app')
  " probably rails
  let b:ctags_command = 'ctags -R app lib vendor'
elseif isdirectory('lib')
  " normal ruby project
  let b:ctags_command = 'ctags -R lib'
endif
~~~
