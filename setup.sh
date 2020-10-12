set -e

DESTINATION="$HOME/src/github.com/${USER}/dotfiles"
RBENV_INSTALL_DIR="$HOME/.rbenv"

# Install vim bundles
vim +PlugInstall +qall

# Install prerequisites
brew install zsh vim ag tmux reattach-to-user-namespace

# Install iterm2
brew install iterm2

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

