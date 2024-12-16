# Dotfiles

## About these dotfiles

These are config files to set up a system the way I like it.

## Installation

    export DESTINATION="$HOME/src/github.com/faun/dotfiles"
    export INSTALL_SCRIPT_URL="https://gist.githubusercontent.com/faun/67fadc3f1525399da236589562cb4583/raw/install_dotfiles.sh?$(date +%s)"
    curl -sSL -o dotfiles_installer.sh "$INSTALL_SCRIPT_URL"
    chmod +x ./dotfiles_installer.sh
    ./dotfiles_installer.sh

## Configuration

There are a number of settings that can be configured for these dotfiles. They are:

##### Git

Create a file at `~/.gitconfig.local`:

    [user]
      name = Your Name
      email = email@example.com

    [github]
      user = username

##### Vim

Add any additional settings in `~/.vimrc.local` or `.vimrc.local` in a project directory for project-specific settings

##### Shell config

Add any additional configuration settings to `~/.local.sh` and these will be sourced at login.

Things that can be added to this file include custom aliases, configuration settings, private environment variables, paths, etc.

### Change shell to latest Zsh

    brew install zsh

Add Homebrew Zsh to /etc/shells

    sudo sh -c 'echo "$(which zsh)" >> /etc/shells'

Set Homebrew Zsh as your default user

    sudo chsh -s $(which zsh) $(whoami)

Install tmux

    brew install tmux
    brew install reattach-to-user-namespace

### Patch your terminal font with Powerline glyphs for maximum awesomeness

See [Powerline repo](https://github.com/Lokaltog/powerline-fonts) for more info.

My personal favorite is [inconsolata-dz](https://github.com/Lokaltog/powerline-fonts/raw/master/InconsolataDz/Inconsolata-dz%20for%20Powerline.otf).

### Integrate iTerm2 with tmux

See [iTerm2 downloads](http://code.google.com/p/iterm2/downloads/list) for more info
