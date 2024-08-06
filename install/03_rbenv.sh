#!/usr/bin/env bash

set -eou pipefail

RBENV_ROOT=${RBENV_ROOT:-$HOME/.rbenv}
RBENV_PLUGIN_DIR="$RBENV_ROOT/plugins"

install_rbenv() {
	# Clone the rbenv repo and install plugins
	echo "Installing rbenv and ruby-build"
	curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
	mkdir -p "$RBENV_PLUGIN_DIR"
	git clone https://github.com/rkh/rbenv-whatis.git "$RBENV_PLUGIN_DIR/rbenv-whatis" || git -C "$RBENV_PLUGIN_DIR/rbenv-whatis" pull
	git clone https://github.com/rkh/rbenv-use.git "$RBENV_PLUGIN_DIR/rbenv-use" || git -C "$RBENV_PLUGIN_DIR/rbenv-use" pull
	git clone https://github.com/rbenv/rbenv-each.git "$RBENV_PLUGIN_DIR/rbenv-each" || git -C "$RBENV_PLUGIN_DIR/rbenv-each" pull

	curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash
}

install_rbenv

PATH="$PATH:${RBENV_ROOT}/bin"

INSTALL_RUBY_VERSIONS=${RUBY_VERSIONS_TO_INSTALL:-1}
echo "Installing the latest $INSTALL_RUBY_VERSIONS versions of MRI Ruby"
for ruby_version in $(rbenv install -l | grep -v - | tail "-$INSTALL_RUBY_VERSIONS"); do
	echo "Installing $ruby_version"
	rbenv install -s "$ruby_version"
	rbenv global "$ruby_version"
done

echo "Done."
