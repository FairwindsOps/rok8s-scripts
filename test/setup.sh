#!/bin/bash

export PATH=$PATH:$(pwd)/bin

echo "Installing Shellcheck"
scversion="v0.5.0"
wget "https://storage.googleapis.com/shellcheck/shellcheck-$scversion.linux.x86_64.tar.xz"
tar --xz -xvf "shellcheck-$scversion.linux.x86_64.tar.xz"
mv shellcheck-$scversion/shellcheck /usr/bin/shellcheck
chmod +x /usr/bin/shellcheck
shellcheck --version
rm -rf shellcheck-$scversion/shellcheck

echo "Installing rok8s-scripts Dependencies"
install-rok8s-requirements

echo "Installing Semver"
pip install semver
