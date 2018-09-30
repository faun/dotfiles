# Dotfiles

## About these dotfiles

These are config files to set up a system the way I like it.

## Installation

    export DESTINATION="$HOME/src/github.com/faun/dotfiles";
    url="https://git.io/viGsj"
    script_file=$(mktemp)
    echo "===="
    curl -s -L "$url" | tee "$script_file"
    echo ""
    echo "===="
    printf "Do you want to run this script? [yN]"
    read line
    case $line in
      [Yy]|[Yy][Ee][Ss]) bash "$script_file";;
    esac

or, for the terminally lazy:
    
    export DESTINATION="$HOME/src/github.com/faun/dotfiles"; curl -L https://git.io/viGsj | bash

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

Fix an apple mis-configuration for Zsh

    sudo mv -i /etc/zshenv /etc/zprofile

Install tmux

    brew install tmux
    brew install reattach-to-user-namespace

Install rbenv (recommended)

    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

### Patch your terminal font with Powerline glyphs for maximum awesomeness:
  See [Powerline repo](https://github.com/Lokaltog/powerline-fonts) for more info.

  My personal favorite is [inconsolata-dz](https://github.com/Lokaltog/powerline-fonts/raw/master/InconsolataDz/Inconsolata-dz%20for%20Powerline.otf).

### Integrate iTerm2 with tmux
  See [iTerm2 downloads](http://code.google.com/p/iterm2/downloads/list) for more info
