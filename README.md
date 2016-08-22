# Dotfiles

## About these dotfiles

These are config files to set up a system the way I like it.

## Prerequisites:

* Git >= 1.7.10
* Vim >= 7.4 (brew install vim)

### Recommended tools:

* NeoVim

```
    brew install neovim/neovim/neovim
```

* Tmux with 24-bit Support:

```
brew uninstall tmux
brew install https://raw.githubusercontent.com/choppsv1/homebrew-term24/master/tmux.rb
```

## Installation

    export USERNAME="faun";
    export DESTINATION="$HOME/src/github.com/${USERNAME}/dotfiles";

    url="https://git.io/vKoGI"
    script_file=$(mktemp)
    curl -q -L "$url" | tee "$script_file"
    printf "Do you want to run this script? [yN]"
    read line
    case $line in
      [Yy]|[Yy][Ee][Ss]) sh "$script_file";;
    esac

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
