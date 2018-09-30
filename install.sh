#!/usr/bin/env bash

set -e
shopt -s extglob

cd "$(dirname "$0")" || exit 1; DIR="$(pwd)"

if [[ -n $DEBUG ]]
then
  set -x
fi

# -----------------------------------------------------------------------------

# Accept the XCode license agreement
XCODE_EXIT_CODE=$(xcodebuild > /dev/null 2>&1; echo $?)
if [[ "$XCODE_EXIT_CODE" = "69" ]]
then
  echo "Please accept the xcode license terms:"
  sudo xcodebuild -license accept
fi

if [[ "$OSTYPE" == linux* ]]; then
  sudo apt-get install build-essential curl file git

  if ! [[ -d "$HOME/.linuxbrew" ]]
  then
    git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
    test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
    test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
    test -r ~/.bash_profile && echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.bash_profile
    echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.profile
  fi
fi

xcode-select --install > /dev/null 2>&1 || true

# -----------------------------------------------------------------------------

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"

excludes=(
LICENSE
fonts
install.sh
install
mac_os_defaults
)

excluded_suffixes='@(sh|md)'
for suffix in "${excluded_suffixes[@]}"
do
  excludes+=(*.$suffix)
done

shouldLinkFile () {
  for file in "${excludes[@]}"
  do
    if [[ "$file" == "$1" ]]
    then
      return 1
    else
      return 0
    fi
  done
}

for name in *
do
  target="$HOME/.$name"

  if [[ "$name" == "default-gems" ]]
  then
    target="$HOME/.rbenv/$name"
  fi

  if [[ "$name" == "nvim" ]]
  then
    target="$HOME/.config/$name"
  fi

  if [[ "$name" == "yamllint" ]]
  then
    mkdir -p "$HOME/.config/yamllint/"
    target="$HOME/.config/yamllint/config"
  fi

  should_link=$(shouldLinkFile "$name"; echo $?)

  if [[ $should_link == 0 ]]
  then
    if [[ -L "$target" ]]
    then
      rm "$target"
    fi
    if [[ ! -e "$target" ]]
    then
      echo "Linking $name => $target"
      ln -s "$DIR/$name" "$target"
    elif [[ -d "$target" || -f "$target" ]]
    then
      echo "Skipping existing file $name"
      echo "Move $target out of the way and run again"
    else
      echo "Unknown file type: $target"
    fi
  fi
done

mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"

nvimrc="$XDG_CONFIG_HOME/nvim"
if [[ ! -e "$nvimrc" ]]
then
  echo "Linking nvim"
  ln -s "$HOME/.vim" "$nvimrc"
fi

# -----------------------------------------------------------------------------


"$DIR/install/link_vendored_scripts.sh"

# -----------------------------------------------------------------------------

mkdir -p "$HOME/.local/share/nvim/"
mkdir -p "$HOME/.nvim/tmpfiles"
mkdir -p "$HOME/.vim/spell"
touch "$HOME/.vim/spell/en.utf-8.add"

# -----------------------------------------------------------------------------

# Install n from GitHub

N_PREFIX="${N_PREFIX:-$HOME/n}"
echo "N_PREFIX: $N_PREFIX"
if ! [[ -d "$N_PREFIX/n" ]]
then
  curl -sL https://git.io/n-install | bash -s -- -q
else
  export N_PREFIX
  "$N_PREFIX/bin/n-update" -y
fi

# -----------------------------------------------------------------------------

if ! brew ls --versions | awk '{ print $1 }' | grep 'neovim$' > /dev/null
then
  brew install neovim
fi

# -----------------------------------------------------------------------------

if ! which yarn > /dev/null
then
  npm install -g yarn
fi

npm_packages=(
diff-so-fancy
tern
csslint
stylelint
prettier
eslint
eslint-plugin-prettier
eslint-config-prettier
babel-eslint
eslint-plugin-react
nginxbeautifier
strip-ansi-cli
)

for package in "${npm_packages[@]}"
do
  echo "Installing package: $package"
  yarn global add "$package" --silent --no-progress --no-emoji 2> /dev/null || true
done

# -----------------------------------------------------------------------------

rubygems_packages=(neovim scss_lint)
for gem in "${rubygems_packages[@]}"
do
  echo "Installing gem: $gem"
  rvm "@global do gem install $gem" 2> /dev/null || gem install "$gem"
done

# -----------------------------------------------------------------------------

"$DIR/install/install_python.sh"

# -----------------------------------------------------------------------------

echo "Installing spelling dictionaries"
nvim -u .nvimtest +q

# -----------------------------------------------------------------------------

echo "Updating and installing vim plugins"

nvim +PlugInstall +qa
nvim +PlugUpdate +qa
nvim +PlugClean +qa

# -----------------------------------------------------------------------------

echo "Updating remote plugins"
nvim +UpdateRemotePlugins +qa

# -----------------------------------------------------------------------------

if [[ -z $SKIP_HEALTH_CHECK ]]
then
  nvim +CheckHealth
  echo export SKIP_HEALTH_CHECK=true >> ~/.local.sh
  export SKIP_HEALTH_CHECK=true
fi

echo "Done."
