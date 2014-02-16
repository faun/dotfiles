# Handle the fact that this file will be used with multiple OSs
platform=`uname`
if [[ $platform == 'Linux' ]]; then
  alias a='ls -lrth --color'
  alias ls='ls --color=auto'
  alias get='sudo apt-get install'
  export EDITOR=$(which vim)
elif [[ $platform == 'FreeBSD' ]]; then
  export EDITOR=$(which vi)
elif [[ $platform == 'Darwin' ]]; then
  alias a='ls -lrthG'
  alias ls='ls -G'  # OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
  alias show_invisibles='defaults write com.Apple.Finder AppleShowAllFiles true'
  alias hide_invisibles='defaults write com.Apple.Finder AppleShowAllFiles false'
  alias open_html='open -a Safari build/*/index_us.html'
  alias lock="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
  alias flushdns="sudo killall -HUP mDNSResponder"
  alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'
  export EDITOR='vim'
  if [ -d /Applications/MacVim.app/ ]; then
    # use MacVim over built-in Mac OS version
    export PATH="/Applications/MacVim.app/Contents/MacOS:$PATH"
    alias mvim='MacVim'
    alias vim='Vim'
    alias vi='Vim'
    export EDITOR='/Applications/MacVim.app/Contents/MacOS/Vim'
    alias vimdiff="Vim -d"
  fi
fi

if [ -f $HOME/.local.sh ]; then
  source $HOME/.local.sh
fi
