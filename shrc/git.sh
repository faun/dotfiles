# git
alias got='git'
alias get='git'

# git status
alias gs='git status'
alias g='git status -sb'

# git pull
alias glf='git pull --ff-only'
alias glr='git pull --rebase'

# git push
alias gpo="git push --set-upstream origin $(git branch | awk '/^\* / { print $2 }') >> /dev/null"

# git add
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'

# git clone
alias gcl='git clone'

# git commit
alias gcm='git commit -v -m'
alias gcam='git commit -a -m'
alias amend='git commit --amend'

# git diff
alias gdc='git diff --cached'
alias dt='git difftool'
alias dtc='git difftool --cached'
alias dth='git difftool HEAD'

show() {
  # Show a given commit in git difftool
  args=("$1")
  if [ "x${args}" != "x" ];then
    git difftool "${args}~1..${args}"
  else
    echo "Usage: show SHA"
  fi
}

# Show commits that differ from the master branch
divergent () {
  if [[ "${1}" == "--bare" ]]
  then
    command_opt='--format=%h'
  else
    command_opt='--left-right --graph --cherry-pick --oneline'
  fi
  current_branch="$(git rev-parse --abbrev-ref HEAD)"
  if [[ "${current_branch}" == "master" ]]
  then
    echo "This command cannot be run against the master branch"
  else
    git log $(echo "$command_opt") master..${current_branch}
  fi
}

alias changelog='git log `git log -1 --format=%H -- CHANGELOG*`..; cat CHANGELOG*'

alias stashpop="git stash && git pull && git stash pop"
alias grm='git status --porcelain | ruby -e "puts STDIN.read.scan(/^\\s+D\\s+(.+)\$/).join(\"\\n\")" | xargs git rm'

alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %aN: %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias lg="gg"
alias ggg="git log --graph --pretty=format:'%C(yellow)%h %Creset(%cr)%nAuthor: %C(green)%aN <%aE>%Creset%n%n    %Cblue%s%Creset%n'"
alias gggg="git log --pretty=format:'%C(yellow)%h %Creset(%cr) %C(green)%aN <%aE>%Creset%n%Cblue%s%Creset%n ' --numstat"
alias gitmine="git log --author='$(git config --get user.name)' --pretty=format:'%Cgreen%ad%Creset %s%C(yellow)%d%Creset %Cred(%h)%Creset' --date=short"
alias today='git lg --since="1 day ago"'
alias mark_as_safe='[ -d .git ] && mkdir .git/safe || echo "Run this command at the root of a git repository"'

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
