# Shell Profile/Config File
# NOTE: symlinked to multiple files to apply in multiple shells/scenarios; see install.sh

###############################################################################
# Non-interactive shell configuration
###############################################################################

OS=$(uname -s)

# Add user-specific bin dirs to PATH
export PATH="$PATH:$HOME/.local/bin:$HOME/bin"

# Setup user-specific Python overrides
if [ "$OS" = "Darwin" ]; then
	for PY_DIR in "$HOME/Library/Python/"*/; do
		export PATH="$PY_DIR/bin:$PATH"
	done
fi

# Homebrew
if [ "$OS" = "Darwin" ]; then
	export PATH="$PATH:$HOME/homebrew/bin"
	BREW_BIN=$(command -v brew 2>/dev/null)
	if [ "$BREW_BIN" ]; then
		BREW_PREFIX=$(brew --prefix)
		export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications --require-sha"
		export HOMEBREW_NO_INSECURE_REDIRECT=1
		# help build tools find all the brew-based bits
		export CFLAGS="-I$BREW_PREFIX/include/"
		export CXXFLAGS="-I$BREW_PREFIX/include/"
		export LDFLAGS="-L$BREW_PREFIX/lib/"
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
HISTSIZE=100000
if [ ! "$ZSH_VERSION" ]; then
	HISTFILESIZE=$HISTSIZE
	HISTCONTROL="ignoreboth"
	shopt -s histappend
	PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
else
	SAVEHIST=$HISTSIZE
	setopt SHARE_HISTORY
	setopt EXTENDED_HISTORY
	setopt HIST_EXPIRE_DUPS_FIRST
	setopt HIST_IGNORE_SPACE # ignore if leading space
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
alias tree="tree -C -F"
alias grep="grep --color --exclude-dir={.svn,.git,node_modules}"
alias man='LESS_TERMCAP_md=$(tput bold && tput setaf 4 || :) LESS_TERMCAP_me=$(tput sgr0 || :) LESS_TERMCAP_mb=$(tput blink || :) LESS_TERMCAP_us=$(tput setaf 2 || :) LESS_TERMCAP_ue=$(tput sgr0 || :) LESS_TERMCAP_so=$(tput smso || :) LESS_TERMCAP_se=$(tput rmso || :) PAGER="${commands[less]:-$PAGER}" man'
alias vi=vim

# aliases for node
alias node-print="node -e 'let [,f=\".\",e=\"this\"]=process.argv,ctx; try{ctx=require(f)}catch{ctx=require(path.resolve(f))}; eval(\`(async function(){ with(this) return (\${e}); })\`).call(ctx).then(console.log,e=>{console.error(e);process.exit(1)})'"
alias node-print-json="node -e 'let [,f=\".\",e=\"this\"]=process.argv,ctx; try{ctx=require(f)}catch{ctx=require(path.resolve(f))}; eval(\`(async function(){ with(this) return (\${e}); })\`).call(ctx).then(o=>console.log(JSON.stringify(o,null,2)),e=>{console.error(e);process.exit(1)})'"
alias node-print-table="node -e 'let [,f=\".\",e=\"this\"]=process.argv,ctx; try{ctx=require(f)}catch{ctx=require(path.resolve(f))}; eval(\`(async function(){ with(this) return (\${e}); })\`).call(ctx).then(console.table,e=>{console.error(e);process.exit(1)})'"
alias node-print-deep="node -e 'let [,f=\".\",e=\"this\"]=process.argv,ctx; try{ctx=require(f)}catch{ctx=require(path.resolve(f))}; eval(\`(async function(){ with(this) return (\${e}); })\`).call(ctx).then(o=>console.log(require(\"util\").inspect(o,{depth:process.env.DEPTH||Infinity})),e=>{console.error(e);process.exit(1)})'"
alias node-print-repl="node -e 'let [,f=\".\",e=\"this\"]=process.argv,ctx; try{ctx=require(f)}catch{ctx=require(path.resolve(f))}; eval(\`(async function(){ with(this) return (\${e}); })\`).call(ctx).then((r)=>(console.log(r,\`\n = \\\$1\`),repl.start().context.\$1=r),e=>{console.error(e);process.exit(1)})'"
alias env-ts-node="TS_NODE_FILES=true NODE_OPTIONS=\"-r ts-node/register \$NODE_OPTIONS\""
alias ts-node-print="env-ts-node node-print"

# color diffs
! command -v colordiff >/dev/null  ||  alias diff="colordiff"

# color json
! command -v json >/dev/null  ||  alias json="json -o inspect"

# color theme setup for bat (not aliased to cat directly because it's a bit slow)
command -v bat >/dev/null  ||  export BAT_THEME="$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo 'Visual Studio Dark+' || echo GitHub)"

# fancy shell prompts
if [ "$ZSH_VERSION" ]; then

	if [ "$OS" = "Darwin" ]; then
		# Enable zsh completions from brew
		ZSH_SITE_FUNC_DIR="$BREW_PREFIX/share/zsh/site-functions"
		FPATH="$ZSH_SITE_FUNC_DIR:$FPATH"

		# Auto fetch some community completions
		for ID in _yarn; do
			[ -f "$ZSH_SITE_FUNC_DIR/$ID" ] || curl -s -o "$ZSH_SITE_FUNC_DIR/$ID" "https://raw.githubusercontent.com/zsh-users/zsh-completions/master/src/$ID"
		done
	fi

	ANTIGEN_DIR="$HOME/.antigen"
	[ -d "$ANTIGEN_DIR" ] || mkdir "$ANTIGEN_DIR"
	ANTIGEN_BIN="$ANTIGEN_DIR/antigen.zsh"
	[ -f "$ANTIGEN_BIN" ] || curl -L git.io/antigen > "$ANTIGEN_BIN"
	source "$ANTIGEN_BIN"

	BUNDLES=(
		zsh-users/zsh-syntax-highlighting
		mafredri/zsh-async@main
		sindresorhus/pure@main
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
	# check window size after each command
	shopt -s checkwinsize

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
				cd "$HOME${PWD##"$ABS_HOME"}" || :
			fi
		fi
	fi
fi
