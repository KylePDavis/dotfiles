###############################################################################
# Non-interactive shell configuration
###############################################################################

OS=$(uname -s)

# Add user-specific bin dirs to PATH
export PATH="$PATH:$HOME/.local/bin:$HOME/bin"

# Setup user-specific Python overrides
if [ "$OS" = "Darwin" ]; then
	export PATH="$HOME/Library/Python/2.7/bin:$PATH:$HOME/bin"
fi

# Homebrew
if [ "$OS" = "Darwin" ]; then
	export PATH="$PATH:$HOME/homebrew/bin"
	BREW_BIN=$(command -v brew 2>/dev/null)
	if [ "$BREW_BIN" ]; then
		BREW_PREFIX=$(brew --prefix)
		export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications --require-sha"
		export HOMEBREW_NO_INSECURE_REDIRECT=1
	fi
fi

# Default editor
export EDITOR="vim"

# Help things find Google Chrome
if [ "$OS" = "Darwin" ]; then
	CHROME_BIN="$HOME/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
	! [ -f "$CHROME_BIN" ]  ||  export CHROME_BIN
fi

# Configure go lang
if [ "$OS" = "Darwin" ]; then
	export GOROOT="$BREW_PREFIX/opt/go/libexec"
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
if [ ! "$ZSH_VERSION" ]; then
	HISTFILESIZE=500000
	HISTCONTROL="ignoreboth"
	shopt -s histappend
	PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
else
	SAVEHIST=500000
	# https://www.refining-linux.org/archives/49-ZSH-Gem-15-Shared-history.html
	setopt inc_append_history
	setopt share_history

fi

# check window size after each command
if [ ! "$ZSH_VERSION" ]; then
	shopt -s checkwinsize
fi

# Custom shell aliases
if [ "$OS" = "Darwin" ]; then
	export CLICOLOR=1
else
	alias ls="ls --color=auto"
	alias pbcopy="xclip -selection clipboard"
	alias pbpaste="xclip -selection clipboard -o"
fi
alias la="ls -Fa"
alias ll="ls -Fla"
alias l="ls -FC"
alias d="l"
alias tree="tree -CF"
alias grep="grep --color --exclude-dir={.svn,.git,node_modules}"
alias node-print="node -p -e '(process.argv[2]||\"\").split(\".\").filter(Boolean).reduce((o,k)=>o[k],require(path.resolve(process.argv[1])))'"

# color diffs
! command -v colordiff &>/dev/null  ||  alias diff="colordiff"

# color json
! command -v json &>/dev/null  ||  alias json="json -o inspect"

# MacVim shell aliases
if [ "$OS" = "Darwin" ]; then
	alias gvim="mvim"
fi

# fancy shell prompts
if [ "$ZSH_VERSION" ]; then

	ANTIGEN_DIR="$HOME/.antigen"
	[ -d "$ANTIGEN_DIR" ] || mkdir "$ANTIGEN_DIR"
	ANTIGEN_BIN="$ANTIGEN_DIR/antigen.zsh"
	[ -f "$ANTIGEN_BIN" ] || curl -L git.io/antigen > "$ANTIGEN_BIN"
	source "$ANTIGEN_BIN"

	BUNDLES=(
		zsh-users/zsh-syntax-highlighting
		mafredri/zsh-async
		sindresorhus/pure
		ael-code/zsh-colored-man-pages
	)
	for B in ${=BUNDLES}; do
		antigen bundle "$B"
	done
	antigen apply

	# use emacs-style for most defaults
	bindkey -e

	# jump more like bash did
	bindkey "^[f" vi-forward-word
	bindkey "^[b" vi-backward-word

	# editor
	autoload -z edit-command-line
	zle -N edit-command-line
	bindkey "^X^E" edit-command-line

	# enable completion menu
	zstyle ':completion:*' menu select

	# allow trailing slashes on ".."
	zstyle ':completion:*' special-dirs true

	# ensure proper ls-style colors in completion
	zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
else
	# tab completion FTW
	if [ "$OS" = "Darwin" ]; then
		F="$BREW_PREFIX/etc/bash_completion";  ! [ -f "$F" ]  ||  source "$F"
		F="$(xcode-select -p)/usr/share/git-core/git-completion.$SHELL_NAME";  ! [ -f "$F" ]  ||  source "$F"
	else
		F="/etc/bash_completion";  ! [ -f "$F" ]  ||  source "$F"
	fi
	F="$HOME/.liquidprompt/liquidprompt";  ! [ -f "$F" ]  ||  source "$F"
fi

# gimme gimme
[ -d "$HOME/.gimme" ]  ||  curl -fsSL "https://github.com/KylePDavis/gimme/raw/master/gimme" | bash -
#F="$HOME/.gimme/gimme";  ! [ -f "$F" ]  ||  source "$F"

# The VS Code terminal needs a few tweaks
if [ "$TERM_PROGRAM" = "vscode" ]; then

	# patch to restore some of the option as meta escape key in VS Code on Mac
	if [ "$ZSH_VERSION" ]; then
		bindkey "≥" insert-last-word
	fi

	# detect if in a fully resolved HOME path and cd back to the shorter version
	if [ "$PWD" != "$HOME" ]; then
		ABS_HOME="$(cd "$HOME" && pwd -P)"
		if [ "$ABS_HOME" != "$HOME" ]; then
			if [[ "$PWD" =~ $ABS_HOME* ]]; then
				cd "$HOME${PWD##$ABS_HOME}" || :
			fi
		fi
	fi
fi
