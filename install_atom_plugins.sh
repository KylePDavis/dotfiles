#!/bin/bash
# An installable list of the Atom IDE plugins that I use.
# To get "apm" tool: open Atom and click "Atom->Install Shell Commands"
apm install "$(cat<<-EOF
Sublime-Style-Column-Selection
Tern
Zen
angularjs
ask-stack
atom-beautify
atom-bootstrap3
atom-cli-diff
atom-color-highlight
atom-html-preview
atom-lint
atomatigit
atomic-rest
center-screen
change-case
coffee-refactor
color-picker
copy-as-rtf
coverage
docblockr
editorconfig
file-icons
filesize
git-blame
git-difftool
git-log
git-plus
git-tab-status
go-plus
hex
highlight-cov
highlight-line
highlight-selected
js-refactor
language-svg
linter
linter-clang
linter-coffeelint
linter-cpplint
linter-csslint
linter-javac
linter-js-yaml
linter-jshint
linter-pep8
linter-perl
linter-pylint
linter-scss-lint
linter-shellcheck
linter-write-good
linter-xmllint
live-archive
markdown-format
merge-conflicts
mocha-test-runner
nbsp-detect
node-debugger
open-in-sourcetree
open-last-project
open-terminal-here
pain-split
pdf-view
pipe
project-colorize
recent-files
refactor
regex-railroad-diagram
revert-buffer
script
sort-lines
stacktrace
svg-preview
task-list
term2
test-jumper
test-status
todo-show
trailing-spaces
tualo-git-context
turbo-javascript
EOF
)"
