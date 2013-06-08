# Alt Ctags

An alternative ctags plugin for vim. Automatically runs ctags 
asynchronously on save of any git-controlled file.

## Installation

1. Use pathogen
2. Clone to `~/.vim/bundle/alt-ctags`

## Options

| Setting                | Default value      | Notes
| ---                    | ---                | ---
| **g:alt_ctags_loaded** | unset              | Setting this value prevents alt-ctags from loading at all
| **g:ctags_command**    | `ctags -f '%f' -R` | `%f` represents the output file
| **g:ctags_file**       | `tags`             |
| **g:ctags_excludes**   | `['~']`            | Ctags will not be run in these directories (a trailing `/` is required)
| **b:ctags_command**    | unset              | Buffer-specific override

## Notes

The `%f` in the ctags commands is required because we actually generate 
to a temporary file then move it into place. This prevents intermittent 
errors if vim attempts to access the file while it's being generated.

## Examples

**ftplugin/ruby.vim**

~~~ { .vim }
if isdirectory('app')
  " probably rails
  let b:ctags_command = "ctags -f '%f' -R --exclude='*.js' --langmap='ruby:+.rake.builder.rjs' --languages=-javascript app lib vendor"
else
  " typical ruby project
  let b:ctags_command = "ctags -f '%f' -R lib"
endif
~~~

**ftplugin/haskell.vim**

~~~ { .vim }
let b:ctags_command = 'echo ":ctags %f" | ghci -v0 main.hs'
~~~
