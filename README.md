## About these dotfiles

These are config files to set up a system the way I like it.

![iTerm solarized](http://cl.ly/1m312N052t0m3P2W1D3V/iTerm%20Solarized.png "iTerm solarized")

### Step 1: Install dotfiles

    # Make src directory if it doesn't exist
    mkdir -p ~/src

    # Clone this repository to your machine & initialize submodules (submodule init requires git >= 1.6.5)
    git clone --recursive git://github.com/faun/dotfiles ~/src/dotfiles

### Step 2: Install

    rake

### Step 3: Customize

There are a number of settings that can be configured for these dotfiles. They are:

##### Git (This requires installing Git version 1.7.10 or greater)

Create a file at `~/.gitignore.local`:

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

    echo "/usr/local/bin/zsh" >> /etc/shells

Set Homebrew Zsh as your default user

    sudo chsh -s /usr/local/bin/zsh $(whoami)

Fix an apple mis-configuration for Zsh

    sudo mv -i /etc/zshenv /etc/zprofile

Install tmux

    brew install tmux
    brew install reattach-to-user-namespace

Install RVM (recommended)

    curl -L get.rvm.io | bash -s stable

### Patch your terminal font with Powerline glyphs for maximum awesomeness:
  See [Powerline repo](https://github.com/Lokaltog/vim-powerline/tree/develop/fontpatcher) for more info.

### Integrate iTerm2 with tmux
  See [iTerm2 downloads](http://code.google.com/p/iterm2/downloads/list) for more info
