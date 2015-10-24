#!/bin/bash
# An installable list of the Atom IDE plugins that I use.
# To get "apm" tool: open Atom and click "Atom->Install Shell Commands"
apm install $(cat<<-EOF
Sublime-Style-Column-Selection
angularjs
atom-beautify
atom-bootstrap3
atom-cli-diff
atom-html-preview
atom-ternjs
atom-typescript
atomatigit
autocomplete-emojis
center-screen
change-case
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
hex
highlight-selected
keybinding-cheatsheet
language-diff
language-jade
language-mumps
language-svg
language-viml
linter
linter-clang
linter-coffeelint
linter-cpplint
linter-csslint
linter-eslint
linter-javac
linter-js-yaml
linter-jscs
linter-jshint
linter-less
linter-pep8
linter-perl
linter-pylint
linter-scss-lint
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
quick-highlight
revert-buffer
script
sort-lines
svg-preview
term2
trailing-spaces
turbo-javascript
vim-mode
EOF
)

#NOTE: eventually remove this in favor of using eslint exclusively
# enable jscs jsdoc extension within atom
gimme node
cd "$HOME/.atom/"
npm install jscs-jsdoc
