export PATH="$PATH:$HOME/bin"

# Homebrew
export PATH="$PATH:$HOME/homebrew/bin"
export PYTHONPATH="$(brew --prefix)/lib/python2.7/site-packages/"  # also facilitates:  easy_install -d "$PYTHONPATH" awesome_pkg

# Homebrew cask
export HOMEBREW_CASK_OPTS="--caskroom=$HOME/homebrew/Caskroom --binarydir=$HOME/homebrew/bin"

# Custom shell aliases
alias ls="ls -FG"
alias d="ls"
alias tree='tree -CF'
alias grep="grep --color --exclude-dir=.svn --exclude-dir=.git --exclude-dir=node_modules"

# MacVim shell aliases
alias gvim="mvim"

# Default editor
export EDITOR="vim"

# bash completion FTW
! [ -f "$(brew --prefix)/etc/bash_completion" ]  ||  . "$(brew --prefix)/etc/bash_completion"

# color diffs
! which colordiff &>/dev/null  ||  alias diff="colordiff"

# Git shell aliases
F="/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash";  ! [ -f "$F" ]  ||  . "$F"

# Liquid Prompt
F="$HOME/liquidprompt/liquidprompt";  ! [ "$PS1" -a -f "$F" ]  ||  . "$F"

# go lang
export GOROOT="$(brew --prefix go)"
export PATH="$PATH:$GOROOT/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=500000

# make less allow and use colors
export LESS="-FRX"


###############################################################################
# Installers
###############################################################################

_install_homebrew() {
	xcode-select --install 2>&1 | grep -q "already installed"  ||  exit
	[ -d "$HOME/homebrew" ]  ||  (mkdir "$HOME/homebrew" 2>/dev/null  &&  curl -L "https://github.com/Homebrew/homebrew/tarball/master" | tar xz --strip 1 -C "$HOME/homebrew"  &&  brew update)
	brew install caskroom/cask/brew-cask
}

_install_tools() {
	_install_homebrew
	[ -d "$HOME/liquidprompt" ]  ||  git clone "https://github.com/nojhan/liquidprompt.git" "$HOME/liquidprompt"
	which tmux >/dev/null  ||  brew install tmux
	which tree >/dev/null  ||  brew install tree
	[ -f "$HOME/.bash_profile" ]  ||  ln -sv "$HOME/.profile" "$HOME/.bash_profile"
	[ -f "$HOME/.bashrc" ]        ||  ln -sv "$HOME/.profile" "$HOME/.bashrc"
	[ -f "$HOME/.gitconfig" ]  ||  (
		git config --global color.ui true
		git config --global credential.helper "$([ "$(uname -s)" = "Darwin" ] && echo "osxkeychain" || echo "cache --timeout=3600")"
	)
	which git-alias >/dev/null  ||  brew install git-extras
	[ "$(git alias)" ]  ||  (
		git alias br branch
		git alias ci commit
		git alias co checkout
		git alias di diff
		git alias st status
	)
	[ -d "$HOME/Applications/SourceTree.app" ]     ||  brew cask install sourcetree
	[ -d "$HOME/Applications/Atom.app" ]           ||  brew cask install atom
	[ -d "$HOME/Applications/Google Chrome.app" ]  ||  brew cask install google-chrome
	[ -d "$HOME/Applications/Firefox.app" ]        ||  brew cask install firefox
}

_install_dev_js() {
	_install_homebrew
	which node >/dev/null  ||  brew install node
	PKG=jshint;       which "$PKG" >/dev/null  ||  npm install -g "$PKG"
	PKG=js-beautify;  which "$PKG" >/dev/null  ||  npm install -g "$PKG"
	PKG=json;         which "$PKG" >/dev/null  ||  npm install -g "$PKG"
	PKG=jscs;         which "$PKG" >/dev/null  ||  npm install -g "$PKG"
}

_install_dev_sh() {
	_install_homebrew
	which shellcheck >/dev/null  ||  brew install shellcheck
}

_install_dev_py() {
	_install_homebrew
	mkdir -p "$PYTHONPATH"
	PKG=pylint;  which "$PKG" >/dev/null  ||  (easy_install -d "$PYTHONPATH" "$PKG"  &&  ln -sv "$PYTHONPATH/$PKG" "$(brew --prefix)/bin/$PKG")
	PKG=pep8;    which "$PKG" >/dev/null  ||  (easy_install -d "$PYTHONPATH" "$PKG"  &&  ln -sv "$PYTHONPATH/$PKG" "$(brew --prefix)/bin/$PKG")
}

_install_dev_db() {
	_install_homebrew
	which mongod >/dev/null  ||  brew install mongodb     &&  ln -sfv "$(brew --prefix mongodb)"/*.plist ~/Library/LaunchAgents/
	which redis >/dev/null   ||  brew install redis       &&  ln -sfv "$(brew --prefix redis)"/*.plist ~/Library/LaunchAgents/
	which pg_config          ||  brew install postgresql  &&  ln -sfv "$(brew --prefix postgrsql)"/*.plist ~/Library/LaunchAgents/
}

_install_dev_go() {
	_install_homebrew
	which go >/dev/null  ||  brew install go --with-cc-common
}

