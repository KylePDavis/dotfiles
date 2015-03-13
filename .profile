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
	export CLICOLOR="1"
fi
alias d="l"
alias l="ls -CF"
alias la="ls -A"
alias ll="ls -alF"
alias tree="tree -CF"
export GREP_OPTIONS="--color --exclude-dir=.svn --exclude-dir=.git --exclude-dir=node_modules"

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
F="$HOME/.liquidprompt/liquidprompt";  ! [ "$PS1" -a -f "$F" ]  ||  . "$F"

# gimme gimme
[ -d "$HOME/.gimme" ]  ||  curl -fsSL "https://github.com/KylePDavis/gimme/raw/master/gimme" | bash -
! [ -f "$HOME/.gimme/gimme" ]  ||  . "$HOME/.gimme/gimme"

