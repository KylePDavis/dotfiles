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

- `.profile`
  - package management via [gimme][gimme] (wraps `apt-get`, [brew][brew], etc.)
  - nice prompts via [pure][pure] in `zsh` or [liquidprompt][liquidprompt] in `bash`
  - colors for many common operations
- `.vimrc`
  - compatible with [nvim][nvim]
  - automatic plugin management via [zgenom][zgenom]
  - improved colors and tabs behaviors
  - IDE-level features for several languages
  - inline colors for CSS
  - gutter for VCS/SCM changes (e.g., `git`)

[gimme]: https://github.com/KylePDavis/gimme
[brew]: http://brew.sh
[liquidprompt]: https://github.com/nojhan/liquidprompt
[pure]: https://github.com/sindresorhus/pure
[nvim]: https://neovim.io
[zgenom]: https://github.com/jandamm/zgenom
