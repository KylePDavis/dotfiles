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

FILES="
	.profile
	.vimrc
	.eslintrc.js
	.irbrc
"

for FILE in $FILES; do
	link "$CMD_DIR/$FILE" "$HOME/"
done

# extra links for .profile
link "$CMD_DIR/.profile" "$HOME/.zshrc"
link "$CMD_DIR/.profile" "$HOME/.bashrc"
link "$CMD_DIR/.profile" "$HOME/.bash_profile" # certain scenarios use this one

OS=$(uname -s)
if [ "$OS" = "Darwin" ]; then
	# Enable "All Controls" for tab in: System Settings > Keyboard > Keyboard navigation
	defaults write -globalDomain AppleKeyboardUIMode -int 3

	# Setup things for: System Settings > Keyboard > Keyboard Shortcuts > App Shortcuts
	Sep="\033" KCmd='@' KOpt='~' KCtrl='^' KShift='$' KLeft='\U2190' KRight='\U2192'
	defaults write -globalDomain NSUserKeyEquivalents -dict-add \
		"${Sep}Window${Sep}Zoom" "${KCmd}${KOpt}${KCtrl}m" \
		"${Sep}Window${Sep}Move Window to Left Side of Screen" "${KCmd}${KOpt}${KCtrl}${KLeft}" \
		"${Sep}Window${Sep}Move Window to Right Side of Screen" "${KCmd}${KOpt}${KCtrl}${KRight}" \
		"${Sep}Window${Sep}Tile Window to Left of Screen" "${KCmd}${KOpt}${KCtrl}${KShift}${KLeft}" \
		"${Sep}Window${Sep}Tile Window to Right of Screen" "${KCmd}${KOpt}${KCtrl}${KShift}${KRight}" \
		"${Sep}Window${Sep}Move Window Back to Mac" "${KCmd}${KOpt}${KCtrl}1"

	# Nudge the prefs daemon to reload things
	killall cfprefsd
fi
