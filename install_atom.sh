#!/bin/bash
set -e
set -x
mkdir -p ~/Applications/
cd ~/Applications/
curl -sL -o Atom.zip https://atom.io/download/mac
unzip Atom.zip
rm Atom.zip
