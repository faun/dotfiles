alias show_invisibles='defaults write com.Apple.Finder AppleShowAllFiles true'
alias hide_invisibles='defaults write com.Apple.Finder AppleShowAllFiles false'
alias open_html='open -a Safari build/*/index_us.html'
alias lock="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
alias flushdns="sudo discoveryutil mdnsflushcache"
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

if ps -ax | grep '[b]oot2docker' 2>&1 /dev/null
then
  if [[ "$(boot2docker status)" -eq "running" ]]
  then
    export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375
  fi
fi
