alias show_invisibles='defaults write com.Apple.Finder AppleShowAllFiles true'
alias hide_invisibles='defaults write com.Apple.Finder AppleShowAllFiles false'
alias open_html='open -a Safari build/*/index_us.html'
alias lock="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
alias flushdns="sudo discoveryutil mdnsflushcache"
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

if ps -ax | grep '[b]oot2docker' > /dev/null
then
  if [[ "$(boot2docker status)" == "running" ]]
  then
    $(boot2docker shellinit 2> /dev/null)
    export DOCKER_IP=$(boot2docker ip 2>/dev/null)
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
