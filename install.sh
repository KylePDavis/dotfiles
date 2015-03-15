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
	if [[ -f "$DST" ]]; then
		if ! [[ -L "$DST" ]]; then
			mkdir -p "${DST%/*}"
			mv -vi "$DST" "$DST.bak"
			ln -sfv "$SRC" "$DST"
		fi
	fi
}

link "$CMD_DIR/.profile" "$HOME/.profile"
link "$CMD_DIR/.profile" "$HOME/.bashrc"

link "$CMD_DIR/.vimrc" "$HOME/.vimrc"

link "$CMD_DIR/.jshintrc" "$HOME/.jshintrc"
link "$CMD_DIR/.jscsrc" "$HOME/.jscsrc"
link "$CMD_DIR/.node-inspectorrc" "$HOME/.node-inspectorrc"
