alias show_invisibles='defaults write com.Apple.Finder AppleShowAllFiles true'
alias hide_invisibles='defaults write com.Apple.Finder AppleShowAllFiles false'
alias open_html='open -a Safari build/*/index_us.html'
alias lock="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
alias flushdns="sudo killall -HUP mDNSResponder"
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

HOMEBREW_PREFIX="$(brew --prefix)"
export HOMEBREW_PREFIX
