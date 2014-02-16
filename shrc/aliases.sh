# directory listing & navigation
alias l="ls -lAh"
alias ll='ls -hl'
alias la='ls -a'
alias lla='ls -lah'

alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias q='exit'

# git
alias got='git'
alias get='git'

# git status
alias gs='git status'
alias g='git status -sb'

# git pull
alias glf='git pull --ff-only'
alias glr='git pull --rebase'

# git add
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'

# git clone
alias gcl='git clone'

# git commit
alias gcm='git commit -v -m'
alias gcam='git commit -a -m'

# git diff
alias gdc='git diff --cached'
alias dt='git difftool'
alias dtc='git difftool --cached'
alias dth='git difftool HEAD'

alias changelog='git log `git log -1 --format=%H -- CHANGELOG*`..; cat CHANGELOG*'

alias stashpop="git stash && git pull && git stash pop"
alias grm='git status --porcelain | ruby -e "puts STDIN.read.scan(/^\\s+D\\s+(.+)\$/).join(\"\\n\")" | xargs git rm'

alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %aN: %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias lg="gg"
alias ggg="git log --graph --pretty=format:'%C(yellow)%h %Creset(%cr)%nAuthor: %C(green)%aN <%aE>%Creset%n%n    %Cblue%s%Creset%n'"
alias gggg="git log --pretty=format:'%C(yellow)%h %Creset(%cr) %C(green)%aN <%aE>%Creset%n%Cblue%s%Creset%n ' --numstat"
alias gitmine="git log --author='$(git config --get user.name)' --pretty=format:'%Cgreen%ad%Creset %s%C(yellow)%d%Creset %Cred(%h)%Creset' --date=short"
alias today='git lg --since="1 day ago"'

# External Tools
alias tower='gittower'
alias gt='gittower'
alias gk='gitk --all&'
alias gx='gitx --all'

gdv() {
  args=("$@")
  git diff -w ${args} | view -
}

gdvc() {
  args=("$@")
  git diff --cached -w ${args} | view -
}

# Subversion & diff
export SVN_EDITOR='${EDITOR}'

alias sv='svn --username ${SV_USER}'
alias svimport='sv import'
alias svcheckout='sv checkout'
alias svstatus='sv status'
alias svupdate='sv update'
alias svstatusonserver='sv status --show-updates' # Show status here and on the server
alias svcommit='sv commit'
alias svadd='svn add'
alias svaddall='svn status | grep "^\?" | awk "{print \$2}" | xargs svn add'
alias svdelete='sv delete'
alias svhelp='svn help'
alias svblame='sv blame'
alias svdiff='sv diff'

# tmux
alias tat='tmux_attach'
alias t='tmux_attach'

# ruby
alias irb='irb --readline -r irb/completion'
alias bi='bundle install'
alias be='bundle exec'

# rails
alias sc='script/console'
alias ss='script/server'
alias sg='script/generate'
alias a='autotest -rails'
alias tlog='tail -f log/development.log'
alias scaffold='script/generate nifty_scaffold'
alias migrate='rake db:migrate db:test:clone'
alias rst='touch tmp/restart.txt'

alias rdm="rake db:migrate"
alias rdtp="rake db:test:prepare"
alias rsa='rake spec:all'
alias rc='rails console'
alias rs='rails server'
alias rsd='rails server --debugger'
alias spec='/usr/bin/time rspec'
# capistrano
alias get_db='cap production db:download && rake db:backup:load'
alias get_db_staging='cap staging db:download && rake db:backup:load SOURCE_ENV=staging'

# Zeus
alias z='zeus'
alias zs='zeus start'

# Docker
alias docker='docker -H tcp://0.0.0.0:4243'

# misc
alias retag='ctags -R --exclude=.svn --exclude=.git --exclude=log *'
alias so='source $HOME/src/dotfiles/shrc/aliases'
alias i='screen -rd irc'
alias f='find . -iname'
alias ducks='du -cksh * | sort -rn|head -11' # Lists folders and files sizes in the current folder
alias m='more'
alias df='df -h'
alias lm='!! | more'

alias py='python'
alias sha1="openssl sha1"

alias heroku='/usr/bin/heroku'
alias aliases='$EDITOR $HOME/src/dotfiles/shrc/aliases'
alias d='cd $HOME/src/dotfiles'

alias showdirs="cat $HOME/.dirs | ruby -e \"puts STDIN.read.split.map{|x| x.gsub(/^(.+)=.+$/, '\1')}.join(', ')\""
