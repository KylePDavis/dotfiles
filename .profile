# Shell Profile/Config File
# NOTE: symlinked to multiple files to apply in multiple shells/scenarios; see install.sh

###############################################################################
# Non-interactive shell configuration
###############################################################################

# utils used below
[ "$ZSH_VERSION" ] && get_bin(){ whence -p "$1"; } || get_bin(){ which "$1"; }
has_bin(){ get_bin "$1" >/dev/null; }
get_func(){ typeset -f "$1"; }
has_func(){ get_func "$1" >/dev/null; }
is_num(){ [[ "$1" =~ ^[0-9]+$ ]]; }
as_num(){ is_num "$1" && echo "$1"; }

OS=$(uname -s)

# Add user-specific bin dirs to PATH
export PATH="$PATH:$HOME/.local/bin:$HOME/bin"

# Setup user-specific Python overrides
_PY_BASE_DIR="$HOME/Library/Python/";
if [ "$OS" = "Darwin" ] && [ -d "$_PY_BASE_DIR" ]; then
	for PY_DIR in "$HOME/Library/Python/"*/; do
		export PATH="$PY_DIR/bin:$PATH"
	done
fi

# Homebrew
if [ "$OS" = "Darwin" ]; then
	export PATH="$PATH:$HOME/homebrew/bin" # maybe keep? will this help on family laptops?
	if [ "${BREW_BIN:=$(get_bin brew)}" ] && [ "${BREW_PREFIX:=$(brew --prefix)}" ]; then
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
export LESS="-FRXM --use-color" #NOTE: --mouse nearly works but selection breaks which is probably more important

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

# Enable auto-switching by adding mise-aware tool shims to PATH (which resolves tool versions lazily and avoids issues caused by other approaches)
! has_bin mise  ||  export PATH="$HOME/.local/share/mise/shims:$PATH"

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
alias grep="grep --color"
alias man='LESS_TERMCAP_md=$(tput bold && tput setaf 4 || :) LESS_TERMCAP_me=$(tput sgr0 || :) LESS_TERMCAP_mb=$(tput blink || :) LESS_TERMCAP_us=$(tput setaf 2 || :) LESS_TERMCAP_ue=$(tput sgr0 || :) LESS_TERMCAP_so=$(tput smso || :) LESS_TERMCAP_se=$(tput rmso || :) PAGER="${commands[less]:-$PAGER}" man'
alias vi=vim

# aliases for node
alias node-print="node -e 'let [,f=\".\",e=\"this\"]=process.argv,ctx=require(fs.existsSync(f)?path.resolve(f):f); eval(\`(async function(){ with(this) return (\${e}); })\`).call(ctx).then(console.log,e=>{console.error(e);process.exit(1)})'"
alias node-print-json="node -e 'let [,f=\".\",e=\"this\"]=process.argv,ctx; try{ctx=require(f)}catch{ctx=require(path.resolve(f))}; eval(\`(async function(){ with(this) return (\${e}); })\`).call(ctx).then(o=>console.log(JSON.stringify(o,null,2)),e=>{console.error(e);process.exit(1)})'"
alias node-print-table="node -e 'let [,f=\".\",e=\"this\"]=process.argv,ctx; try{ctx=require(f)}catch{ctx=require(path.resolve(f))}; eval(\`(async function(){ with(this) return (\${e}); })\`).call(ctx).then(console.table,e=>{console.error(e);process.exit(1)})'"
alias node-print-deep="node -e 'let [,f=\".\",e=\"this\"]=process.argv,ctx; try{ctx=require(f)}catch{ctx=require(path.resolve(f))}; eval(\`(async function(){ with(this) return (\${e}); })\`).call(ctx).then(o=>console.log(require(\"util\").inspect(o,{depth:process.env.DEPTH||Infinity})),e=>{console.error(e);process.exit(1)})'"
alias node-print-repl="node -e 'let [,f=\".\",e=\"this\"]=process.argv,ctx; try{ctx=require(f)}catch{ctx=require(path.resolve(f))}; eval(\`(async function(){ with(this) return (\${e}); })\`).call(ctx).then((r)=>(console.log(r,\`\n = \\\$1\`),repl.start().context.\$1=r),e=>{console.error(e);process.exit(1)})'"
alias env-ts-node="TS_NODE_FILES=true NODE_OPTIONS=\"-r ts-node/register \$NODE_OPTIONS\""
alias ts-node-print="env-ts-node node-print"

# colorized cat using bat
if [ "${BAT_BIN:=$(get_bin bat)}" ]; then
	alias cat="$BAT_BIN -p"

	# Customize theme (note also used by delta)
	export BAT_THEME="$(defaults read -globalDomain AppleInterfaceStyle &>/dev/null && echo 'Visual Studio Dark+' || echo GitHub)"
	#TODO: the VSCode theme in bat is not showing markdown italics, code blocks, or fenced code blocks
	#TODO: enable --italic-text=always via here? or put config in my dotfiles…

	# colorized ripgrep using batgrep
	if [ "${BATGREP_BIN:=$(get_bin batgrep)}" ] && [ "${RG_BIN:=$(get_bin rg)}" ]; then
		rg(){
			if [ $# -ne 1 ] || [ "[$1]" = "[--help]" ]; then
				"$RG_BIN" "$@";
			else
				"$BATGREP_BIN" --search-pattern "$1";
				#TODO: -- can the pager be automatic instead of always while still keeping search-pattern (or similar)?
			fi
		}
	fi

	#TODO: batman is currently worse/different than my current alias but change the color scheme

	# use bat for help
	#TODO: I assume this fails if last arg… I should try to fix that first…
	if [ "$ZSH_VERSION" ]; then
		alias -g -- -h='-h 2>&1 | bat -p -l=help'
		alias -g -- --help='--help 2>&1 | bat -p -l=help'
	fi

	# monkeypatch head to use bat to colorize things
	if [ "${HEAD_BIN:=$(get_bin head)}" ]; then
		head(){
			local N=10
			case "$1" in
				-c*|--bytes*)
					"$HEAD_BIN" "$@"
					;;
				*)
					if [[ "$1" =~ ^-(n|-lines)$ ]] && N=$(as_num "$2"); then
						shift 2
					elif [[ "$1" =~ ^-(n=?|-lines=) ]] && N=$(as_num "${1##*[^0-9]}"); then
						shift 1
					fi
					"$BAT_BIN" --line-range=":$N" "$@"
			esac
		}
	fi

	# monkeypatch git to use bat to colorize things
	if [ "${GIT_BIN:=$(get_bin git)}" ]; then
		git(){
			case "$1" in
				log)
					# A gross hack for git log until this is fixed: https://github.com/sharkdp/bat/issues/1632
					# NOTE: forcing `--decorate` since piping disables it; `bat` won't highlight those lines properly but the info is too useful to omit
					"$GIT_BIN" "$@" --decorate | "$BAT_BIN" -p -l=gitlog
					;;
				show)
					# Use bat to colorize showing files in other branches
					if [[ "$2" =~ ^.+:.+ ]]; then
						"$GIT_BIN" "$@" | "$BAT_BIN" -p --file-name "${2##*:}"
					else
						"$GIT_BIN" "$@";
					fi
					;;
				*)
					"$GIT_BIN" "$@";
					;;
			esac
		}
	fi
fi

if [ "${GH_BIN:=$(get_bin gh)}" ]; then
	# monkeypatch gh to customize some of the templates
	gh(){
		case "$1 $2" in
			"search prs" | "pr list")
				"$GH_BIN" "$@" \
					--json="url,title,author,updatedAt" \
					--template='
{{tablerow "URL" "TITLE" "AUTHOR" "UPDATED"}}
{{range .}}{{tablerow (.url | autocolor "blue") .title .author.login .updatedAt}}{{end}}
'
				;;
			*)
				"$GH_BIN" "$@";
				;;
		esac
	}
fi

# color theme setup for bat (not aliased to cat directly because it's a bit slow)
! has_bin bat  ||  export BAT_THEME="$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo 'Visual Studio Dark+' || echo GitHub)"

# color diffs
! has_bin colordiff  ||  alias diff="colordiff"

#TODO: alias doesn't quite work here for delta because it breaks "diff -u" ... luckily -u is the default and I never want the other format so maybe ignore -u and move on?? 🙄
#! has_bin delta  ||  alias diff="delta" #TODO: make this part of the above …has_bin delta… checks

# color json
! has_bin json  ||  alias json="json -o inspect"


# fancy shell prompts
if [ "$ZSH_VERSION" ]; then
	# use emacs-style for most defaults
	bindkey -e

	# jump more like bash did with Alt + Left/Right arrow
	bindkey "^[f" vi-forward-word
	bindkey "^[b" vi-backward-word

	# bindings for if you're not using Options as Meta key in Terminal (e.g., VSCode)
	bindkey "∑" vi-backward-kill-word  # Alt + w
	bindkey "ƒ" vi-forward-word    # Alt + f
	bindkey "∫" vi-backward-word   # Alt + b
	bindkey "≥" insert-last-word   # Alt + .

	# editor
	autoload -z edit-command-line
	zle -N edit-command-line
	bindkey "^X^E" edit-command-line

	# enable completion menu
	zstyle ':completion:*' menu select

	# allow trailing slashes on ".."
	zstyle ':completion:*' special-dirs true

	# enable inline comments since other shells allow it and sometimes they're nice to have
	setopt interactive_comments

	# ensure proper ls-style colors in completion
	zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

	# setup zgenom and plugins for zsh
	ZGENOM_DIR="${HOME}/.zgenom"
	[ -d "$ZGENOM_DIR" ] || git clone https://github.com/jandamm/zgenom.git "$ZGENOM_DIR"
	source "$ZGENOM_DIR/zgenom.zsh"
	zgenom autoupdate
	if ! zgenom saved; then
		echo "Creating a zgenom save ..."
		zgenom loadall <<EOF
			sindresorhus/pure
			zsh-users/zsh-autosuggestions
			zsh-users/zsh-syntax-highlighting
EOF
		zgenom save
	fi
	ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(backward-kill-word)

	# My Visual Studio Dark+ zsh-syntax-highlighting theme
	[[ $COLORTERM =~ (24bit|truecolor) ]] || zmodload zsh/nearcolor # use nearest for 256-color terminals
	typeset -A ZSH_HIGHLIGHT_STYLES
	export ZSH_HIGHLIGHT_STYLES
	ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets cursor regexp)
	# zsh-syntax-highlighting: main
	ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#F44747'
	ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#C586C0' # if, for, then, etc.
	ZSH_HIGHLIGHT_STYLES[alias]='fg=#DCDCAA'
	ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#DCDCAA'
	ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#DCDCAA'
	ZSH_HIGHLIGHT_STYLES[builtin]='fg=#DCDCAA'
	ZSH_HIGHLIGHT_STYLES[function]='fg=#DCDCAA' # foo in foo(){}
	ZSH_HIGHLIGHT_STYLES[command]='fg=#DCDCAA'  # date in $(date)
	ZSH_HIGHLIGHT_STYLES[precommand]='fg=#DCDCAA,italic' # builtin, command, exec
	ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#D4D4D4' # ;, &&, ||
	ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#FF0000' # what's this?
	ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#6A9955,italic'
	ZSH_HIGHLIGHT_STYLES[path]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#FF79C6'
	ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#FF79C6'
	ZSH_HIGHLIGHT_STYLES[globbing]='fg=#569CD6'
	ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#BD93F9'
	ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#CE9178' # $( … ) -- not the …
	ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#CE9178' # "$( … )" -- not the …
	ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=???'
	ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=#CE9178' # $(( … )) -- not the …
	ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#9CDCFE' # -h
	ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#9CDCFE' # --help
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#BD93F9'
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#F44747'
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#F44747'
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#F44747'
	ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#F44747'
	ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#CE9178'
	ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#9CDCFE'
	ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#D7BA7D' # "\\"" -- only the \\"
	ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#D4D4D4'
	ZSH_HIGHLIGHT_STYLES[assign]='fg=#9CDCFE' # X=123 -- the X=
	ZSH_HIGHLIGHT_STYLES[redirection]='fg=#D4D4D4'
	ZSH_HIGHLIGHT_STYLES[comment]='fg=#6A9955'
	ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#D4D4D4'
	ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#D4D4D4'
	ZSH_HIGHLIGHT_STYLES[arg0]='fg=#DCDCAA'
	ZSH_HIGHLIGHT_STYLES[default]='fg=#D4D4D4'
	# zsh-syntax-highlighting: brackets
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=#D7BA7D' # [[[ -- but only the 1st
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=#C586C0' # [[[ -- but only the 2nd
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=#FFB86C' # [[[ -- but only the 3rd
	# zsh-syntax-highlighting: cursor
	ZSH_HIGHLIGHT_STYLES[cursor]='standout'
	# zsh-syntax-highlighting: regexp
	typeset -A ZSH_HIGHLIGHT_REGEXP
	 #TODO: bug: highlighting unfound vars with same color… ideally undefined vars would be red or dimmed or something
	ZSH_HIGHLIGHT_REGEXP+=('[$][0-9]' fg=#9CDCFE) # $… -- non-quoted dollar-argument
	ZSH_HIGHLIGHT_REGEXP+=('[$][a-zA-Z_][a-zA-Z0-9_]*' fg=#9CDCFE) # $… -- non-quoted dollar-argument
	# ZSH_HIGHLIGHT_REGEXP+=('[$]{[a-zA-Z_][a-zA-Z0-9_]*[:-=/#}]{1,2}' fg=#9CDCFE) # $… -- brace-wrapped dollar-argument
	ZSH_HIGHLIGHT_REGEXP+=(' -[^= ]*' fg=#9CDCFE) # -xyz
	ZSH_HIGHLIGHT_REGEXP+=(' --[^= ]*' fg=#9CDCFE) # --flags=
	ZSH_HIGHLIGHT_REGEXP+=('[#][ ]?[A-Z]{3,13}:' ${ZSH_HIGHLIGHT_STYLES[comment]},bold) # #TODO: <-- comment leaders
	ZSH_HIGHLIGHT_REGEXP+=(' [^ ]+://[^ ?&#]*' ${ZSH_HIGHLIGHT_STYLES[assign]},bold) # proto://some/path <-- URL-like strings

	# Enable zsh completions from brew
	ZSH_SITE_FUNC_DIR="$BREW_PREFIX/share/zsh/site-functions"
	FPATH="$ZSH_SITE_FUNC_DIR:$FPATH"

	# Auto fetch some community completions
	RERUN_ZCOMP=
	for ID in _node _yarn; do
		F="$ZSH_SITE_FUNC_DIR/$ID"; [ -f "$F" ] || curl -s -o "$ZSH_SITE_FUNC_DIR/$ID" "https://raw.githubusercontent.com/zsh-users/zsh-completions/master/src/$ID"  &&  RERUN_ZCOMP=1
	done

	# Setup for bun
	if has_bin bun; then
		F="$ZSH_SITE_FUNC_DIR/_bun"; [ -f "$F" ] || curl -s -o "$F" "https://raw.githubusercontent.com/oven-sh/bun/refs/heads/main/completions/bun.zsh"
		source "$F"
	fi

	# Setup for rustup
	if [ "${RUSTUP_BIN:=$(get_bin rustup)}" ]; then
		# Add rustup completions
		F="$ZSH_SITE_FUNC_DIR/_rustup";  [ -f "$F" ]  &&  ! [ "$RUSTUP_BIN" -nt "$F" ]  ||  rustup completions zsh > "$F"
		source "$F"
	fi

	# Setup for cargo
	F="$HOME/.cargo/env";  ! [ -f "$F" ]  ||  source "$F"
	if [ "${CARGO_BIN:=$(get_bin cargo)}" ]; then
		# Add cargo completions
		F="$ZSH_SITE_FUNC_DIR/_cargo"; [ -f "$F" ]  &&  ! [ "$CARGO_BIN" -nt "$F" ]  ||  rustup completions zsh cargo > "$F"
		# source "$F" -- TODO: fix this… it's not working on my zsh for some reason
	fi

	# Setup for dprint
	if [ "${DPRINT_BIN=$(get_bin dprint)}" ]; then
		# Add dprint completions
		F="$ZSH_SITE_FUNC_DIR/_dprint";  [ -f "$F" ]  &&  ! [ "$DPRINT_BIN" -nt "$F" ]  ||  dprint completions zsh > "$F"
		source "$F"
	fi

	# recompile completions
	[ -z "$RERUN_ZCOMP" ] || compinit
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

# Remove any PATH duplicates for simplicity
export PATH="$(echo "$PATH" | tr : '\n' | awk '!has[$0]++' | tr '\n' :)"

# gimme completions
F="$HOME/.gimme/gimme";  ! [ -f "$F" ]  ||  source "$F"

