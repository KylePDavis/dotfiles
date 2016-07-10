#!/bin/bash
set -o errexit -o pipefail

# support curl|bash
if [[ "$0" =~ [-]?bash ]] && ! [[ "$BASH_SOURCE" ]]; then
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

link "$CMD_DIR/.profile" "$HOME/.profile" # Mac
link "$CMD_DIR/.profile" "$HOME/.bashrc" # Linux
link "$CMD_DIR/.profile" "$HOME/.bash_profile" # certain scenarios use this one

link "$CMD_DIR/.vimrc" "$HOME/.vimrc"

link "$CMD_DIR/.eslintrc.js" "$HOME/.eslintrc.js"
link "$CMD_DIR/.node-inspectorrc" "$HOME/.node-inspectorrc"

mkdir -p "$HOME/.atom"
for F in "$CMD_DIR/atom/"*; do
	FN=${F##*/}
	link "$CMD_DIR/atom/$FN" "$HOME/.atom/$FN"
done
if ! [[ -d "$HOME/.atom/packages/" ]]; then
	if which apm &>/dev/null; then
		"$CMD_DIR/install_atom_plugins.sh"
	else
		echo "# WARN: Unable to find Atom's \"apm\" command."
		echo "# WARN: 1. Get Atom from the website or automatically using \"gimme atom\""
		echo "# WARN: 2. Install the atom plugins using \"$CMD_DIR/install_atom_plugins.sh\""
	fi
fi
