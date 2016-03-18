alias show_invisibles='defaults write com.Apple.Finder AppleShowAllFiles true'
alias hide_invisibles='defaults write com.Apple.Finder AppleShowAllFiles false'
alias open_html='open -a Safari build/*/index_us.html'
alias lock="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
alias flushdns="sudo killall -HUP mDNSResponder"
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

if ps -ax | grep 'docker-machine' > /dev/null
then
  if [[ "$(docker-machine status default)" == "Running" ]]
  then
    eval $(docker-machine env default)
  elif [[ "$(docker-machine status default)" == "Stopped" ]]
  then
    echo "Starting Docker..."
    docker-machine start default && eval $(docker-machine env default)
  fi
fi

HOMEBREW_PREFIX="$(brew --prefix)"
export HOMEBREW_PREFIX

if which brew > /dev/null 2>&1
then
  [[ -f ${HOMEBREW_PREFIX}/etc/profile.d/z.sh ]] && source ${HOMEBREW_PREFIX}/etc/profile.d/z.sh

  if [[ -d ${HOMEBREW_PREFIX}/lib/python2.7/ ]]
  then
    export PYTHONPATH="${HOMEBREW_PREFIX}/lib/python2.7/site-packages:$PYTHONPATH"
  fi
fi
