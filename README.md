# Dotfiles

## About these dotfiles

These are config files to set up a system the way I like it. I primarily use Vim for development. I develop mostly on Mac OS. In Ruby. For the web. With CoffeeScript. If you don't do all of these things on a regular basis, move along. There's not much here that will do you any good.

## Installation

#### Prerequisites:

* Rake
* Git >= 1.7.10

### Step 1: Clone the repository with submodules

    # Make src directory if it doesn't exist
    mkdir -p ~/src

    # Clone this repository to your machine & initialize submodules
    git clone --recursive git://github.com/faun/dotfiles ~/src/dotfiles

### Step 2: Install

    # Make symlinks to $HOME
    rake

    # Install vim bundles
    vim +BundleInstall +qall

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
