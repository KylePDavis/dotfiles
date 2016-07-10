#!/bin/bash
# An installable list of the Atom IDE plugins that I use.
# To get "apm" tool: open Atom and click "Atom->Install Shell Commands"
apm install $(cat<<-EOF
Sublime-Style-Column-Selection
atom-beautify
atom-html-preview
atom-ternjs
atom-typescript
atomatigit
autocomplete-emojis
color-picker
copy-as-rtf
coverage
docblockr
editorconfig
file-icons
filesize
git-blame
git-control
git-difftool
git-log
git-plus
go-plus
highlight-selected
language-diff
language-svg
language-viml
linter
linter-clang
linter-cpplint
linter-csslint
linter-eslint
linter-javac
linter-js-yaml
linter-less
linter-pep8
linter-perl
linter-pylint
linter-sass-lint
linter-shellcheck
linter-tslint
linter-write-good
linter-xmllint
man
merge-conflicts
open-in-sourcetree
open-terminal-here
pdf-view
pigments
pipe
script
sort-lines
svg-preview
term3
trailing-spaces
turbo-javascript
vim-mode
EOF
)

