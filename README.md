dotfiles
========

My obligatory dotfiles repository to track and share my personal config files.

I tend to keep my customizations lightweight.

This also serves as a tool for getting new Mac OS X systems setup in a hurry.



Highlights
==========

* `.profile`
  - a handful of integrated `_install_*` functions to make setup easier
  - uses [liquidprompt][liquidprompt] for awesome shell prompts
  - uses [homebrew][homebrew] for integration with common tools
* `.vimrc`
  - uses [Vim-Plug][vim-plug] to automatically install and load plugins
  - tweaks colors and tabs
  - syntax checking
  - JavaScript and CoffeeScript support
  - inline colors for CSS
  - gutter for VCS changes
* [Atom][atom] editor scripts
  - a Mac OS X install script for the [Atom][atom] IDE to make it _even easier_
  - an install script for the plugins that I use



Installation
============

Clone it
--------
```bash
git clone https://github.com/KylePDavis/dotfiles.git
```

Symlink things
--------------
```bash
ln -s dotfiles/.vimrc ~/.vimrc
ln -s dotfiles/.profile ~/.profile
```



[liquidprompt]: https://github.com/nojhan/liquidprompt
[homebrew]: http://brew.sh
[atom]: https://atom.io
[vim-plug]: https://github.com/junegunn/vim-plug
