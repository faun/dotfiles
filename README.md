##Faun's Dot Files

These are config files to set up a system the way I like it.

![iTerm solarized](http://cl.ly/1m312N052t0m3P2W1D3V/iTerm%20Solarized.png "iTerm solarized")

###Step 1: Install dotfiles

    #make src directory if it doesn't exist
    mkdir -p ~/src

    #clone this repository to your machine, initialize submodules (submodule init requires git >= 1.6.5)
    git clone --recursive git://github.com/faunzy/dotfiles ~/src/dotfiles

###Step 2: Install

    rake

###Additional Tools

Install Command-T C extension:

    #if using rvm: rvm use system
    cd vim/bundle/command-t/ruby/command-t/
    ruby extconf.rb
    make

###Change shell to latest zsh

    brew install zsh


Add homebrew zsh to /etc/shells

    echo "/usr/local/bin/zsh" >> /etc/shells

Set homebrew zsh as your default user

    sudo chsh -s /usr/local/bin/zsh $(whoami)

###Patch your terminal font with Powerline glyphs for maximum awesomeness:
  See [Powerline repo](https://github.com/Lokaltog/vim-powerline/tree/develop/fontpatcher) for more info.

###Integrate iTerm2 with tmux
  See [iTerm2 downloads](http://code.google.com/p/iterm2/downloads/list) for more info
