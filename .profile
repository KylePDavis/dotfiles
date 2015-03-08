###############################################################################
# Non-interactive shell configuration
###############################################################################

OS=$(uname -s)

# Add $HOME/bin to PATH
export PATH="$PATH:$HOME/bin"

# Homebrew
export PATH="$PATH:$HOME/homebrew/bin"
BREW_BIN=$(which brew)
BREW_PREFIX=$(which brew &>/dev/null  &&  brew --prefix  || echo "")
if [ "$BREW_BIN" ]; then
	export PYTHONPATH="$BREW_PREFIX/lib/python2.7/site-packages/"  # also facilitates:  easy_install -d "$PYTHONPATH" awesome_pkg
	export HOMEBREW_CASK_OPTS="--caskroom=$BREW_PREFIX/Caskroom --binarydir=$BREW_PREFIX/bin"
fi

# Default editor
export EDITOR="vim"

# Configure go lang
if [ "$OS" = "Darwin" ]; then
	export GOROOT="$BREW_PREFIX/opt/go"
else
	export GOROOT="$HOME/golang"
fi
export PATH="$PATH:$GOROOT/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Configure less allow colors
export LESS="-FRX"

# If not running interactively, don't do anything else
[ "$PS1" ]  ||  return


###############################################################################
# Interactive shell configuration
###############################################################################

# tweak history behavior a bit
HISTSIZE=50000
HISTFILESIZE=500000
HISTCONTROL="ignoredups:ignorespace"
shopt -s histappend

# check window size after each command
shopt -s checkwinsize

# Custom shell aliases
if [ "$OS" = "Darwin" ]; then
	alias ls="ls -G -CF"
else
	alias ls="ls --color -CF"
fi
alias ll="ls -alF"
alias la="ls -A"
alias l="ls"
alias d="ls"
alias grep="grep --color --exclude-dir=.svn --exclude-dir=.git --exclude-dir=node_modules"
alias egrep="egrep --color --exclude-dir=.svn --exclude-dir=.git --exclude-dir=node_modules"
alias fgrep="fgrep --color --exclude-dir=.svn --exclude-dir=.git --exclude-dir=node_modules"
alias tree="tree -CF"

# color diffs
! which colordiff &>/dev/null  ||  alias diff="colordiff"

# MacVim shell aliases
if [ "$OS" = "Darwin" ]; then
	alias gvim="mvim"
fi

# bash completion FTW
if [ "$OS" = "Darwin" ]; then
	! [ -f "$BREW_PREFIX/etc/bash_completion" ]  ||  . "$BREW_PREFIX/etc/bash_completion"
else
	! [ -f "/etc/bash_completion" ]  ||  . "/etc/bash_completion"
fi

# Git shell aliases
F="/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash";  ! [ -f "$F" ]  ||  . "$F"

# Liquid Prompt
F="$HOME/liquidprompt/liquidprompt";  ! [ "$PS1" -a -f "$F" ]  ||  . "$F"



###############################################################################
# Installers
###############################################################################

_install_homebrew() {
	xcode-select --install 2>&1 | grep -q "already installed"  ||  exit
	[ -d "$HOME/homebrew" ]  ||  (mkdir "$HOME/homebrew" 2>/dev/null  &&  curl -L "https://github.com/Homebrew/homebrew/tarball/master" | tar xz --strip 1 -C "$HOME/homebrew"  &&  brew update)
	which brew-cask >/dev/null  ||  brew install caskroom/cask/brew-cask
}

_install_tools() {
	_install_homebrew
	[ -f "$HOME/.bash_profile" ]  ||  ln -sv "$HOME/.profile" "$HOME/.bash_profile"
	[ -f "$HOME/.bashrc" ]        ||  ln -sv "$HOME/.profile" "$HOME/.bashrc"
	[ -d "$HOME/liquidprompt" ]   ||  git clone "https://github.com/nojhan/liquidprompt.git" "$HOME/liquidprompt"
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
	which tmux >/dev/null  ||  brew install tmux
	which tree >/dev/null  ||  brew install tree
	[ -d "$HOME/Applications/SourceTree.app" ]     ||  brew cask install sourcetree
	[ -d "$HOME/Applications/Atom.app" ]           ||  brew cask install atom
	[ -d "$HOME/Applications/Google Chrome.app" ]  ||  brew cask install google-chrome
	[ -d "$HOME/Applications/Firefox.app" ]        ||  brew cask install firefox
}

_install_dev_js() {
	_install_homebrew
	which node >/dev/null  ||  brew install node
	PKG="jshint";       which "$PKG" >/dev/null  ||  npm install -g "$PKG"
	PKG="js-beautify";  which "$PKG" >/dev/null  ||  npm install -g "$PKG"
	PKG="json";         which "$PKG" >/dev/null  ||  npm install -g "$PKG"
	PKG="jscs";         which "$PKG" >/dev/null  ||  npm install -g "$PKG"
}

_install_dev_sh() {
	_install_homebrew
	which shellcheck >/dev/null  ||  brew install shellcheck
}

_install_dev_py() {
	_install_homebrew
	mkdir -p "$PYTHONPATH"
	PKG="pylint";  which "$PKG" >/dev/null  ||  (easy_install -d "$PYTHONPATH" "$PKG"  &&  ln -sv "$PYTHONPATH/$PKG" "$BREW_PREFIX/bin/$PKG")
	PKG="pep8";    which "$PKG" >/dev/null  ||  (easy_install -d "$PYTHONPATH" "$PKG"  &&  ln -sv "$PYTHONPATH/$PKG" "$BREW_PREFIX/bin/$PKG")
}

_install_dev_db() {
	_install_homebrew
	which mongod >/dev/null     ||  brew install mongodb     &&  ln -sfv "$BREW_PREFIX/opt/mongodb"/*.plist ~/Library/LaunchAgents/
	which redis >/dev/null      ||  brew install redis       &&  ln -sfv "$BREW_PREFIX/opt/redis"/*.plist ~/Library/LaunchAgents/
	which pg_config >/dev/null  ||  brew install postgresql  &&  ln -sfv "$BREW_PREFIX/opt/postgresql"/*.plist ~/Library/LaunchAgents/
}

_install_dev_go() {
	_install_homebrew
	which go >/dev/null  ||  brew install go --with-cc-common
}

