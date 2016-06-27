set -e

DESTINATION="$HOME/src/github.com/${USER}/dotfiles"
RBENV_INSTALL_DIR="$HOME/.rbenv"
HOMEBREW_INSTALL_SCRIPT='http://git.io/pVOl'

# Install Homebrew
command -v brew >/dev/null 2>&1 ||
  ruby -e "$(curl -fsSL $HOMEBREW_INSTALL_SCRIPT)"

# Make the dotfiles folder
mkdir -p $DESTINATION

# Clone this repository to your machine & initialize submodules
if ! [[ -d $DESTINATION ]]
then
  git clone --recursive git://github.com/faun/dotfiles $DESTINATION
fi

# Change working directory
cd $DESTINATION

# Make symlinks to $HOME
rake

# Install vim bundles
vim +PlugInstall +qall

# Install prerequisites
brew install zsh vim ag tmux reattach-to-user-namespace

# Install homebrew-cask
brew install caskroom/cask/brew-cask

# Install iterm2
brew cask install iterm2

if ! [[ $SHELL =~ /(.*)/zsh ]]
then
  # Add Homebrew Zsh to /etc/shells
  sudo sh -c 'echo "$(which zsh)" >> /etc/shells'

  # Set zsh as your default shell
  sudo chsh -s $(which zsh) $(whoami)
fi

# Install rbenv
if ! [[ -d $RBENV_INSTALL_DIR ]]
then
  git clone https://github.com/sstephenson/rbenv.git $RBENV_INSTALL_DIR
fi

brew tap thoughtbot/formulae
brew install rcm


PERSONAL_DOTFILES=$HOME/src/github.com/${USER}/personal_dotfiles
git clone https://github.com/faun/personal_dotfiles.git $PERSONAL_DOTFILES
cd  $PERSONAL_DOTFILES
./install.sh

