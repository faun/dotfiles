#!/usr/bin/env bash

set -eou pipefail

RBENV_ROOT=${RBENV_ROOT:-$HOME/.rbenv}
RBENV_PLUGIN_DIR="$RBENV_ROOT/plugins"

install_rbenv () {
  # Clone the rbenv repo and install plugins
  echo "Installing rbenv and ruby-build"
  git clone https://github.com/rbenv/rbenv.git "$RBENV_ROOT" || true
  mkdir -p "$RBENV_PLUGIN_DIR"
  git clone https://github.com/rbenv/ruby-build.git "$RBENV_PLUGIN_DIR/ruby-build" || true
  git clone git://github.com/jf/rbenv-gemset.git "$RBENV_PLUGIN_DIR/rbenv-gemset" || true
  git clone https://github.com/rkh/rbenv-whatis.git "$RBENV_PLUGIN_DIR/rbenv-whatis" || true
  git clone https://github.com/rkh/rbenv-use.git "$RBENV_PLUGIN_DIR/rbenv-use" || true
  git clone https://github.com/rbenv/rbenv-each.git "$RBENV_PLUGIN_DIR/rbenv-each" || true

  # Compile optional bash extensions
  cd "$RBENV_ROOT" && src/configure && make -C src > /dev/null
}

install_rbenv

PATH="$PATH:${RBENV_ROOT}/bin"

INSTALL_RUBY_VERSIONS=${RUBY_VERSIONS_TO_INSTALL:-1}
echo "Installing the latest $INSTALL_RUBY_VERSIONS versions of MRI Ruby"
for ruby_version in $(rbenv install -l | grep -v - | tail "-$INSTALL_RUBY_VERSIONS")
do
  echo "Installing $ruby_version"
  rbenv install -s "$ruby_version"
  rbenv global "$ruby_version"
done

echo "Setting global Ruby version to: $ruby_version"
rbenv global "$ruby_version"

echo "Done."
