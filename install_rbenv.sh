#!/usr/bin/env bash
set -eou pipefail

RBENV_ROOT=${RBENV_ROOT:-$HOME/.rbenv}
RBENV_PLUGIN_DIR="$RBENV_ROOT/plugins"

install_rbenv () {
  # Clone the rbenv repo and install plugins
  if ! [[ -d "$HOME/.rbenv/.git" ]]
  then
    echo "Installing rbenv and ruby-build"
    git clone https://github.com/rbenv/rbenv.git "$RBENV_ROOT"
    mkdir -p "$RBENV_PLUGIN_DIR"
    git clone https://github.com/rbenv/ruby-build.git "$RBENV_PLUGIN_DIR/ruby-build"
    git clone git://github.com/jf/rbenv-gemset.git "$RBENV_PLUGIN_DIR/rbenv-gemset"
    git clone https://github.com/rkh/rbenv-whatis.git "$RBENV_PLUGIN_DIR/rbenv-whatis"
    git clone https://github.com/rkh/rbenv-use.git "$RBENV_PLUGIN_DIR/rbenv-use"
    git clone https://github.com/rbenv/rbenv-each.git "$RBENV_PLUGIN_DIR/rbenv-each"
  else
    echo "Rbenv is already installed"
  fi

  # Compile optional bash extensions
  cd ~/.rbenv && src/configure && make -C src > /dev/null

  # Determine the current shell
  shell="$(ps -p "$PPID" -o 'args=' 2>/dev/null || true)"
  shell="${shell%% *}"
  shell="${shell##-}"
  shell="${shell:-$SHELL}"
  shell="${shell##*/}"

  # Determine the correct file to add the path modification
  case "$shell" in
  bash )
    if [ -f "${HOME}/.bashrc" ] && [ ! -f "${HOME}/.bash_profile" ]; then
      profile="$HOME/.bashrc"
    else
      profile="$HOME/.bash_profile"
    fi
    ;;
  zsh )
    profile="$HOME/.zshrc"
    ;;
  ksh )
    profile="$HOME/.profile"
    ;;
  fish )
    # shellcheck disable=SC2088
    profile="$HOME/.config/fish/config.fish"
    ;;
  esac

  # Istall PATH modification and rbenv inititialization to shell init files
  if ! echo "$PATH" | grep "$RBENV_ROOT/bin" > /dev/null
  then
    # Add rbenv PATH to shell profile
    # shellcheck disable=SC2016
    if [[ -z ${profile+x} ]]
    then
      echo "Add rbenv PATH to your shell profile and run this command again:"
      echo "export PATH=\"$RBENV_ROOT/bin:\$PATH\""
      exit 1
    else
      echo "export PATH=\"$RBENV_ROOT/bin:\$PATH\"" >> "$profile"
      # Add auto initialization to shell profile
      # shellcheck disable=SC2016
      echo 'eval "$(rbenv init -)"' >> "$profile"
      # Evaluate rbenv initialization so we can use it right away
      export PATH="$RBENV_ROOT/bin:$PATH"
      eval "$(rbenv init -)"
    fi
 else
    echo "Your PATH is correctly configured for rbenv"
  fi

}

install_rbenv

INSTALL_RUBY_VERSIONS=${RUBY_VERSIONS_TO_INSTALL:-3}
echo "Installing the latest $INSTALL_RUBY_VERSIONS versions of MRI Ruby"
for ruby_version in $(rbenv install -l | grep -v - | tail "-$INSTALL_RUBY_VERSIONS")
do
  echo "Installing $ruby_version"
  rbenv install -s "$ruby_version"
done

echo "Done."
