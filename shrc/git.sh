#!/usr/local/env bash
current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

# git
alias got='git'
alias get='git'

# git status
alias g='git status -sb'

# git pull
alias glf='git pull --ff-only'
alias glr='git pull --rebase'

glo() {
  git branch --set-upstream-to=refs/remotes/origin/"$(current_branch)" "$(current_branch)" && git pull --ff-only
}

# git push
alias gp='git push'
gpo() {
  git push --set-upstream origin "$(git branch | awk '/^\* / { print $2 }')" >> /dev/null
}

gpf() {
  branch=$(current_branch)
  if [[ $branch == 'master' ]]
  then
    echo "This command cannot be run from the master branch"
    return 1
  else
    git push origin +"$branch" --force-with-lease
  fi
}

wait_for_ci() {
  RUN_TESTS=$([ -e "circle.yml" ] || [ -e ".travis.yml" ] && echo "true" || echo "false" )
  if [[ $SKIP_CI_CHECK != "true" && $RUN_TESTS != "false" ]]
  then
    echo "Waiting for CI to pass"
    while ! hub ci-status | grep "success" > /dev/null
    do
      printf "."
      sleep 5
    done
  else
    echo "Skipping CI checks"
  fi
}

merge() {
  if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1
  then
    branch=$(current_branch)
    if [[ $branch == 'master' ]]
    then
      echo "This command cannot be run from the master branch"
      return 1
    else
      git fetch &&\
        git diff-index --quiet --cached HEAD && \
        git checkout master && \
        git diff-index --quiet --cached HEAD && \
        git pull origin master && \
        git checkout "$branch" && \
        git rebase master && \
        git push origin +"$branch" --force-with-lease && \
        wait_for_ci && \
        git checkout master && \
        git merge "$branch" --ff-only && \
        sleep 2 && \
        git push origin master && \
        hub browse && \
        sleep 10 && \
        git push origin ":$branch"
    fi
  else
    echo "This command must be run within a git repository"
    return 1
  fi
}

# git add
alias ga='git add'
alias gaa='git add -A .'
alias gap='git add --patch'
alias grh='git reset HEAD'

# git clone
alias gcl='git clone'

# git branches
alias gco='git checkout'
alias gb='git branch'

# git commit
alias gc='git commit -v'
alias gcm='git commit -v -m'
alias gcam='git commit -a -m'
alias gca='git commit -v --amend'
alias amend='git commit -v --amend'

# git diff
alias gd='git diff'
alias gdc='git diff --cached'
alias dt='git difftool'
alias dtc='git difftool --cached'
alias dth='git difftool HEAD'

ds() {
  args="$1"
  if [ "x$args" != "x" ];then
    git diff --stat "$args~1..$args"
  else
    echo "Usage: ds SHA"
  fi
}

compare_to_master() {
  branch="$(current_branch)"
  git diff --stat "master..$branch"
}

diff_with_master() {
  branch="$(current_branch)"
  git difftool "master..$branch"
}

# git rebase
alias grc='git rebase --continue'
alias gri='git fetch && git rebase -i origin/master'

show() {
  # Show a given commit in git difftool
  args="$1"
  if [ "x$args" != "x" ];then
    git difftool "$args~1..$args"
  else
    echo "Usage: show SHA"
  fi
}

# Show commits that differ from the master branch
divergent () {
  branch="$(current_branch)"
  if [[ "${1}" == "--bare" ]]
  then
    command_opt="--format=%h"
  else
    command_opt=(--left-right --graph --cherry-pick --oneline)
  fi
  if [[ "$branch" == "master" ]]
  then
    echo "This command cannot be run against the master branch"
  else
    git log "${command_opt[@]}" master.."$branch"
  fi
}

# Isolate a single commit to its own branch
isolate() {
  if [ "$#" -ne 2 ]
  then
    echo "Usage: isolate <sha> <branch-name>"
    return 1
  else
    git diff-index --quiet --cached HEAD && \
      git checkout master && \
      git diff-index --quiet --cached HEAD && \
      git pull origin master && \
      git diff-index --quiet --cached HEAD && \
      git checkout -b "$2" &&\
      git cherry-pick "$1"
  fi
}

alias changelog='git log `git log -1 --format=%H -- CHANGELOG*`..; cat CHANGELOG*'

alias stashpop="git stash && git pull && git stash pop"
alias grm='git status --porcelain | ruby -e "puts STDIN.read.scan(/^\\s+D\\s+(.+)\$/).join(\"\\n\")" | xargs git rm'

alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %aN: %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ggg="git log --graph --pretty=format:'%C(yellow)%h %Creset(%cr)%nAuthor: %C(green)%aN <%aE>%Creset%n%n    %Cblue%s%Creset%n'"
alias gggg="git log --pretty=format:'%C(yellow)%h %Creset(%cr) %C(green)%aN <%aE>%Creset%n%Cblue%s%Creset%n ' --numstat"
alias gitmine="git log --author='\$(git config --get user.name)' --pretty=format:'%Cgreen%ad%Creset %s%C(yellow)%d%Creset %Cred(%h)%Creset' --date=short"
alias today='git lg --since="1 day ago"'
alias mark_as_safe='[ -d .git ] && mkdir .git/safe || echo "Run this command at the root of a git repository"'

# External Tools
alias tower='gittower'
alias gt='gittower'
alias gk='gitk --all&'
alias gx='gitx --all'

# rewrite authorship
alias reauthor='git commit --amend --reset-author --no-edit'

gdv() {
  args=("$@")
  git diff -w "${args[@]}" | view -
}

gdvc() {
  args=("$@")
  git diff --cached -w "${args[@]}" | view -
}
