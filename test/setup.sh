#!/bin/bash

set -e

#shellcheck disable=SC2155
export PATH=$PATH:$(pwd)/bin

echo "Installing Shellcheck"
scversion="v0.5.0"
wget "https://github.com/koalaman/shellcheck/releases/download/$scversion/shellcheck-$scversion.linux.x86_64.tar.xz"
tar --xz -xvf "shellcheck-$scversion.linux.x86_64.tar.xz"
mv shellcheck-$scversion/shellcheck $(pwd)/bin/shellcheck
chmod +x $(pwd)/bin/shellcheck
shellcheck --version
rm -rf shellcheck-$scversion/shellcheck

echo "Installing rok8s-scripts Dependencies"
ROK8S_INSTALL_PATH=$(pwd)/bin install-rok8s-requirements

echo "Installing Semver"
python -m pip install semver
