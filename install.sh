#!/bin/bash
set -o errexit -o pipefail

# support piping directly into curl
if [[ "$ZSH_VERSION" ]]; then
	setopt posixargzero
fi
if [[ "$0" =~ -?(z|ba)sh && ! "${BASH_SOURCE[*]}" ]]; then
	git clone "https://github.com/KylePDavis/dotfiles" "$HOME/.dotfiles"
	exec "$HOME/.dotfiles/install.sh"
fi

CMD_DIR=$(cd "${BASH_SOURCE%/*}"; echo "$PWD")

link() {
	local SRC=$1
	local DST=$2
	if ! [[ -L "$DST" ]]; then
		if [[ -f "$DST" ]]; then
			mv -vi "$DST" "$DST.bak"
		fi
		mkdir -p "${DST%/*}"
		ln -sfv "$SRC" "$DST"
	fi
}

link "$CMD_DIR/.profile" "$HOME/.profile"
link "$CMD_DIR/.profile" "$HOME/.zshrc"
link "$CMD_DIR/.profile" "$HOME/.bashrc"
link "$CMD_DIR/.profile" "$HOME/.bash_profile" # certain scenarios use this one

link "$CMD_DIR/.vimrc" "$HOME/.vimrc"

link "$CMD_DIR/.eslintrc.js" "$HOME/.eslintrc.js"

mkdir -p "$HOME/.atom"
for F in "$CMD_DIR/atom/"*; do
	FN=${F##*/}
	link "$CMD_DIR/atom/$FN" "$HOME/.atom/$FN"
done
if ! [[ -d "$HOME/.atom/packages/" ]]; then
	if which apm &>/dev/null; then
		echo "# INFO: If you use Atom then you may want to run \"$CMD_DIR/install_atom_plugins.sh\""
	else
		echo "# WARN: Unable to find Atom's \"apm\" command."
		echo "# WARN: 1. Get Atom from the website or automatically using \"gimme atom\""
		echo "# WARN: 2. Install the atom plugins using \"$CMD_DIR/install_atom_plugins.sh\""
	fi
fi

OS=$(uname -s)
if [ "$OS" = "Darwin" ]; then
	# Enable "All Controls" for tab in SystemPreferences->Keyboard->Shortcuts
	defaults write -globalDomain AppleKeyboardUIMode -int 3
	# Setup things for SystemPreferences->Keyboard->Shortcuts->App Shortcuts
	defaults write -globalDomain NSUserKeyEquivalents -dict \
		'\033Window\033Zoom' '@~^m' \
		'\033Window\033Move Window to Left Side of Screen' '@~^\U2190' \
		'\033Window\033Move Window to Right Side of Screen' '@~^\U2192' \
		'\033Window\033Tile Window to Left of Screen' '@~^$\U2190' \
		'\033Window\033Tile Window to Right of Screen' '@~^$\U2192'
fi
