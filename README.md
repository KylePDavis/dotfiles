# dotfiles

My obligatory dotfiles repository to track and share my personal config files.

I tend to keep my customizations lightweight.

This also serves as a tool for getting new Mac OS X and Linux systems setup in a hurry.



## Installation

```bash
curl -fsSL "https://github.com/KylePDavis/dotfiles/raw/master/install.sh" | bash -  &&  . ~/.profile
```
_(you do read these scripts, right?)_



## Highlights

* `.profile`
  - uses [gimme][gimme] to simplify installation (to wrap `apt-get`, [brew][brew], etc)
  - uses [liquidprompt][liquidprompt] for awesome shell prompts
  - colors for less,
* `.vimrc`
  - uses [Vim-Plug][vim-plug] to automatically install and load plugins
  - tweaks colors and tabs
  - syntax checking
  - JavaScript support
  - inline colors for CSS
  - gutter for VCS/SCM changes (e.g., git)
* [Atom][atom] editor scripts
  - an install script for the plugins that I use



[liquidprompt]: https://github.com/nojhan/liquidprompt
[brew]: http://brew.sh
[atom]: https://atom.io
[vim-plug]: https://github.com/junegunn/vim-plug
[gimme]: https://github.com/KylePDavis/gimme
