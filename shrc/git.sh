#!/usr/bin/env bash

current_branch() {
  ref=$(git symbolic-ref HEAD 2>/dev/null) ||
    ref=$(git rev-parse --short HEAD 2>/dev/null) || return
  echo "${ref#refs/heads/}"
}

recent_branches() {
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)' |
    head -n 10
}

is_linked_worktree() {
  local gitdir commondir
  gitdir=$(git rev-parse --git-dir 2>/dev/null) || return 1
  commondir=$(git rev-parse --git-common-dir 2>/dev/null) || return 1
  [[ "$gitdir" != "$commondir" ]]
}

refuse_main_checkout_in_linked_worktree() {
  local target="$1"
  [[ -z "$target" ]] && return 0
  is_linked_worktree || return 0
  local default_branch
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
  [[ -z "$default_branch" ]] && return 0
  if [[ "$target" == "$default_branch" ]]; then
    echo "Refusing to check out '$default_branch' from a linked worktree." >&2
    echo "Use the main worktree for that, or 'recent' to jump there." >&2
    return 1
  fi
  return 0
}

recent_remote_branches() {
  git for-each-ref --sort=-committerdate refs/remotes/origin/ --format='%(refname:short)' |
    sed 's|^origin/||' |
    grep -v '^HEAD$' |
    head -n 25
}

list_worktrees() {
  local wt_path wt_branch
  git worktree list --porcelain 2>/dev/null | while IFS= read -r line; do
    case "$line" in
      worktree\ *)
        wt_path="${line#worktree }"
        ;;
      branch\ *)
        wt_branch="${line#branch refs/heads/}"
        printf '[worktree] %s\t%s\n' "$wt_branch" "$wt_path"
        ;;
    esac
  done
}

# Find the worktree path for a given branch, if it exists
find_worktree_for_branch() {
  local target_branch="$1"
  local wt_path wt_branch
  git worktree list --porcelain 2>/dev/null | while IFS= read -r line; do
    case "$line" in
      worktree\ *)
        wt_path="${line#worktree }"
        ;;
      branch\ *)
        wt_branch="${line#branch refs/heads/}"
        if [[ "$wt_branch" == "$target_branch" ]]; then
          printf '%s\n' "$wt_path"
          return 0
        fi
        ;;
    esac
  done
}

# Set the tmux pane title to the basename of $1 (or $PWD), if inside tmux
_set_tmux_pane_title_from_path() {
  [[ -z ${TMUX:-} ]] && return 0
  local path="${1:-$PWD}"
  # Strip trailing slash, then take the part after the last /
  path="${path%/}"
  tmux select-pane -T "${path##*/}" 2>/dev/null || true
}

# Navigate to wherever the default branch is checked out.
_cd_to_default_branch() {
  local default_branch="$1"
  local target
  target=$(find_worktree_for_branch "$default_branch")

  if [[ -z $target ]]; then
    # Not checked out in any worktree — fall back to primary worktree
    target=$(git worktree list --porcelain | awk '/^worktree /{print substr($0,10); exit}')
  fi

  if [[ -n $target && -d $target ]]; then
    cd "$target" || return 1
    echo "Changed to: $target"
    _set_tmux_pane_title_from_path "$target"
  else
    return 1
  fi
}

recent() {
  local selection worktree_path show_remote=false

  if [[ "$1" == "--remote" || "$1" == "-r" ]]; then
    show_remote=true
  fi

  local local_branches
  local_branches=$(recent_branches)

  if [[ "$show_remote" == true ]]; then
    # Show remote branches not already listed as local
    selection="$({
      recent_remote_branches | while read -r branch; do
        if ! echo "$local_branches" | grep -qxF "$branch"; then
          echo "[remote] $branch"
        fi
      done
    } | fzf || return 1)"
  else
    # Combine worktrees and recent local branches for fzf selection
    selection="$({
      list_worktrees
      echo "$local_branches" | while read -r branch; do
        echo "[branch] $branch"
      done
    } | fzf --with-nth=1,2 || return 1)"
  fi

  if [[ -z $selection ]]; then
    return 1
  fi

  if [[ $selection == "[worktree]"* ]]; then
    local selected_branch
    selected_branch=$(echo "$selection" | awk '{print $2}')
    worktree_path=$(echo "$selection" | cut -f2)

    # If the selected branch is the default branch, go to the primary worktree
    local default_branch
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if [[ -n $default_branch && "$selected_branch" == "$default_branch" ]]; then
      _cd_to_default_branch "$default_branch"
      return $?
    fi

    if [[ -d $worktree_path ]]; then
      cd "$worktree_path" || return 1
      echo "Changed to worktree: $worktree_path"
      _set_tmux_pane_title_from_path "$worktree_path"
    else
      echo "Worktree path not found: $worktree_path"
      return 1
    fi
  elif [[ $selection == "[branch]"* ]]; then
    local branch_to_checkout
    branch_to_checkout=$(echo "$selection" | sed 's/^\[branch\] //')

    # If the selected branch is the default branch, go to the primary worktree
    local default_branch
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    if [[ -n $default_branch && "$branch_to_checkout" == "$default_branch" ]]; then
      _cd_to_default_branch "$default_branch"
      return $?
    fi

    local existing_worktree
    existing_worktree=$(find_worktree_for_branch "$branch_to_checkout")
    if [[ -n $existing_worktree && -d $existing_worktree ]]; then
      cd "$existing_worktree" || return 1
      echo "Changed to worktree: $existing_worktree"
      _set_tmux_pane_title_from_path "$existing_worktree"
    else
      refuse_main_checkout_in_linked_worktree "$branch_to_checkout" || return 1
      # Create a new worktree for the branch
      local worktree_dir
      worktree_dir="$(git rev-parse --show-toplevel)/../worktrees/$branch_to_checkout"
      git worktree add "$worktree_dir" "$branch_to_checkout" || return 1
      cd "$worktree_dir" || return 1
      echo "Created worktree: $worktree_dir"
      _set_tmux_pane_title_from_path "$worktree_dir"
    fi
  elif [[ $selection == "[remote]"* ]]; then
    local branch_to_checkout worktree_dir
    branch_to_checkout=$(echo "$selection" | sed 's/^\[remote\] //')

    # Create a new worktree for the remote branch
    worktree_dir="$(git rev-parse --show-toplevel)/../worktrees/$branch_to_checkout"
    git worktree add "$worktree_dir" "$branch_to_checkout" || return 1
    cd "$worktree_dir" || return 1
    echo "Created worktree: $worktree_dir"
  else
    return 1
  fi
}

heroku_remote() {
  app=$(heroku apps --all | awk '/-staging.*/' | awk '{print $1}' | fzf)
  git remote add "$app" "https://git.heroku.com/$app.git"
}

# Ensure origin/HEAD is configured as a symbolic reference
ensure_origin_head_set() {
  # Check if origin/HEAD is configured
  if ! git symbolic-ref refs/remotes/origin/HEAD &>/dev/null; then
    echo "Setting up origin/HEAD..."
    if git remote set-head origin -a &>/dev/null; then
      return 0
    else
      # If auto-detection fails, try setting to main/master
      if git show-ref --verify --quiet refs/remotes/origin/main; then
        git remote set-head origin main
      elif git show-ref --verify --quiet refs/remotes/origin/master; then
        git remote set-head origin master
      else
        echo "Error: Cannot determine default branch. Please run: git remote set-head origin <branch-name>"
        return 1
      fi
    fi
  fi
}

# Validate git repository setup
validate_git_setup() {
  # Check if we're in a git repo
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: Not in a git repository"
    return 1
  fi

  # Check for origin remote
  if ! git remote get-url origin &>/dev/null; then
    echo "Error: No 'origin' remote configured"
    return 1
  fi

  # Ensure origin/HEAD is set
  ensure_origin_head_set
}

git_remote_mainline_ref() {
  # Ensure origin/HEAD is configured before trying to use it
  if ! ensure_origin_head_set; then
    return 1
  fi
  git rev-parse --abbrev-ref origin/HEAD | cut -c8-
}

untracked_files() {
  git ls-files --exclude-standard --others 2>/dev/null | wc -l | awk '{ print $1 }'
}

is_index_clean() {
  if git diff-index --quiet HEAD -- 2>/dev/null; then
    return 0
  else
    return 1
  fi
}

# git
alias got='git'
alias get='git'

# git status
alias g='git status -sb'

# git pull
alias glf='git pull --ff-only'
alias glr='git pull --rebase'

# git cherry-pick
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"

# git rebase

alias grc="git rebase --continue"
alias gra="git rebase --abort"

# Open the current branch in GitHub

alias branch="gh browse -b \$(current_branch)"
alias pr="gh pr view --web"

glo() {
  git branch --set-upstream-to=refs/remotes/origin/"$(current_branch)" "$(current_branch)" && git pull --ff-only
}

# git push
alias gp='git push'
gpo() {
  local branch
  branch=$(git branch --show-current)
  if [[ -z "$branch" ]]; then
    echo "Error: not on a branch (detached HEAD state)" >&2
    return 1
  fi
  git push --set-upstream origin "HEAD:$branch"
}

gpf() {
  branch=$(current_branch)
  if [[ $branch == "$(git_remote_mainline_ref)" ]]; then
    echo "This command cannot be run from the $(git_remote_mainline_ref) branch"
    return 1
  else
    git push origin +"$branch" --force-with-lease
  fi
}

ci_status_url() {
  hub ci-status -v | awk '{ print $2 }'
}

wait_for_ci() {
  RUN_TESTS=$([ -e "circle.yml" ] || [ -e ".travis.yml" ] && echo "true" || echo "false")
  if [[ $SKIP_CI_CHECK != "true" && $RUN_TESTS != "false" ]]; then
    echo "Waiting for CI to pass"
    while ! hub ci-status | grep "success" >/dev/null; do
      printf "."
      sleep 5
    done
  else
    echo "Skipping CI checks"
  fi
}

merge() {
  if [ -d .git ] || git rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(current_branch)
    if [[ $branch == "$(git_remote_mainline_ref)" ]]; then
      echo "This command cannot be run from the $(git_remote_mainline_ref) branch"
      return 1
    else
      git fetch &&
        git diff-index --quiet --cached HEAD &&
        git checkout "$(git_remote_mainline_ref)" &&
        git diff-index --quiet --cached HEAD &&
        git pull origin "$(git_remote_mainline_ref)" &&
        git checkout "$branch" &&
        git rebase "$(git_remote_mainline_ref)" &&
        git push origin +"$branch" --force-with-lease &&
        wait_for_ci &&
        git checkout "$(git_remote_mainline_ref)" &&
        git merge "$branch" --ff-only &&
        sleep 2 &&
        git push origin "$(git_remote_mainline_ref)" &&
        hub browse &&
        sleep 10 &&
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
function gco() {
  # If no arguments, or first arg is a flag, pass through to git checkout
  if [[ $# -eq 0 || "$1" == -* ]]; then
    git checkout "$@"
    return $?
  fi

  # Check if the first argument matches a branch that lives in a worktree
  local worktree_path
  worktree_path=$(find_worktree_for_branch "$1")
  if [[ -n $worktree_path && -d $worktree_path ]]; then
    cd "$worktree_path" || return 1
    echo "Changed to worktree: $worktree_path"
  else
    refuse_main_checkout_in_linked_worktree "$1" || return 1
    git checkout "$@"
  fi
}
alias gb='git branch'

# git commit
alias gc='git commit -v'
alias gcm='git commit -v -m'
alias gcmn='git commit -v -n -m'
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
  if [ "x$args" != "x" ]; then
    git diff --stat "$args~1..$args"
  else
    git diff --stat --cached
  fi
}

changed_from_mainline() {
  branch="$(current_branch)"
  git diff --stat --name-only "$(git_remote_mainline_ref)..$branch"
}

diffstat_with_mainline() {
  branch="$(current_branch)"
  git diff --stat "$(git_remote_mainline_ref)..$branch"
}

diff_with_mainline() {
  branch="$(current_branch)"
  git difftool "$(git_remote_mainline_ref)..$branch"
}

# git rebase
alias grc='git rebase --continue'
alias gri="git fetch origin \$(git_remote_mainline_ref) && git rebase -i origin/\$(git_remote_mainline_ref)"

show() {
  # Show a given commit in git difftool
  args="$1"
  if [ "x$args" != "x" ]; then
    git difftool "$args~1..$args"
  else
    echo "Usage: show SHA"
  fi
}

# Show commits that differ from the mainline branch
divergent() {
  branch="$(current_branch)"
  if [[ "${1}" == "--bare" ]]; then
    command_opt="--format=%h"
  else
    command_opt=(--left-right --graph --cherry-pick --oneline)
  fi
  if [[ "$branch" == "$(git_remote_mainline_ref)" ]]; then
    echo "This command cannot be run against the $(git_remote_mainline_ref) branch"
  else
    git log "${command_opt[@]}" "$(git_remote_mainline_ref)".."$branch"
  fi
}

# Isolate a single commit to its own branch
isolate() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: isolate <sha> <branch-name>"
    return 1
  else
    if [[ "$(is_index_clean)" -gt 0 ]] || [[ "$(untracked_files)" -gt 0 ]]; then
      echo "Please stash or commit your changes first"
      return 1
    else
      git checkout -b "$2" &&
        git reset --hard "origin/$(git_remote_mainline_ref)" &&
        git cherry-pick "$1"
    fi
  fi
}

gg() {
  # Validate git setup before proceeding
  if ! validate_git_setup; then
    return 1
  fi

  local mainline_ref
  mainline_ref="$(git_remote_mainline_ref)"
  if [[ $? -ne 0 ]]; then
    echo "Error: Could not determine mainline branch"
    return 1
  fi

  if [[ "$(current_branch)" != "$mainline_ref" ]]; then
    git fetch origin "$mainline_ref"
  fi
  git log \
    --graph \
    --pretty=format:'%Cred%h%Creset %aN: %s %Cgreen(%cr)%Creset' \
    --abbrev-commit \
    --date=relative \
    "$(current_branch)" \
    --not "refs/remotes/origin/$mainline_ref"
}

gs() {
  # Validate git setup before proceeding
  if ! validate_git_setup; then
    return 1
  fi

  local mainline_ref
  mainline_ref="$(git_remote_mainline_ref)"
  if [[ $? -ne 0 ]]; then
    echo "Error: Could not determine mainline branch"
    return 1
  fi

  if [[ "$(current_branch)" != "$mainline_ref" ]]; then
    git fetch origin "$mainline_ref"
  fi
  git log \
    --stat \
    "$(current_branch)" \
    --not "refs/remotes/origin/$mainline_ref" \
    "$@"
}

alias changelog='git log `git log -1 --format=%H -- CHANGELOG*`..; cat CHANGELOG*'

alias stashpop="git stash && git pull && git stash pop"
alias grm='git status --porcelain | ruby -e "puts STDIN.read.scan(/^\\s+D\\s+(.+)\$/).join(\"\\n\")" | xargs git rm'

alias log="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %aN: %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ggg="git log --graph --pretty=format:'%C(yellow)%h %Creset(%cr)%nAuthor: %C(green)%aN <%aE>%Creset%n%n    %Cblue%s%Creset%n'"
alias gggg="git log --pretty=format:'%C(yellow)%h %Creset(%cr) %C(green)%aN <%aE>%Creset%n%Cblue%s%Creset%n ' --numstat"
alias gitmine="git log --author='\$(git config --get user.name)' --pretty=format:'%Cgreen%ad%Creset %s%C(yellow)%d%Creset %Cred(%h)%Creset' --date=short"
alias today='git lg --since="1 day ago"'
mark_as_safe() {
  local toplevel
  toplevel="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Run this command inside a git repository"
    return 1
  }
  if git config --file ~/.gitconfig.local --get-all safe.directory 2>/dev/null \
      | grep -Fxq -- "$toplevel"; then
    echo "$toplevel is already marked as safe"
    return 0
  fi
  git config --file ~/.gitconfig.local --add safe.directory "$toplevel"
  echo "Marked $toplevel as safe"
}

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

clean_branches() {
  git checkout "$(git_remote_mainline_ref)" &&
    git diff-index --quiet --cached HEAD &&
    git branch --merged |
    grep -v "[*+]" |
      grep -v "$(git_remote_mainline_ref)" |
      xargs -n 1 git branch -d &&
    echo "Done."
}

# Remove git worktrees that are no longer needed
# A worktree is stale when it has no uncommitted changes AND
# its remote branch is deleted OR its PR is merged/closed
clean_worktrees() {
  local dry_run=false
  local remove_all=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        dry_run=true
        shift
        ;;
      --all)
        remove_all=true
        shift
        ;;
      *)
        echo "Usage: clean_worktrees [--dry-run] [--all]"
        echo "  --dry-run  Preview which worktrees would be removed"
        echo "  --all      Remove all stale worktrees without prompting"
        return 1
        ;;
    esac
  done

  # Validate git setup
  if ! validate_git_setup; then
    return 1
  fi

  local main_worktree
  main_worktree=$(git worktree list --porcelain | head -1 | sed 's/worktree //')

  local stale_worktrees=()
  local worktree_info=()

  # Parse worktree list
  while IFS= read -r line; do
    if [[ "$line" =~ ^worktree\ (.+)$ ]]; then
      local wt_path="${BASH_REMATCH[1]}"

      # Skip the main worktree
      if [[ "$wt_path" == "$main_worktree" ]]; then
        continue
      fi

      local branch=""
      local status_info=""
      local is_stale=false

      # Read the rest of this worktree's info
      while IFS= read -r subline && [[ -n "$subline" ]]; do
        if [[ "$subline" =~ ^branch\ refs/heads/(.+)$ ]]; then
          branch="${BASH_REMATCH[1]}"
        fi
      done

      # Skip if no branch (detached HEAD or bare)
      if [[ -z "$branch" ]]; then
        continue
      fi

      # Check for uncommitted changes
      if ! git -C "$wt_path" diff-index --quiet HEAD -- 2>/dev/null; then
        status_info="[dirty]"
        continue  # Skip dirty worktrees
      fi

      # Check for untracked files
      if [[ -n "$(git -C "$wt_path" ls-files --exclude-standard --others 2>/dev/null)" ]]; then
        status_info="[untracked files]"
        continue  # Skip worktrees with untracked files
      fi

      # Check if remote branch exists
      local remote_exists=true
      if ! git ls-remote --heads origin "$branch" 2>/dev/null | grep -q .; then
        remote_exists=false
        status_info="[remote deleted]"
        is_stale=true
      fi

      # Check PR status if remote still exists
      if [[ "$remote_exists" == true ]]; then
        local pr_state
        pr_state=$(gh pr view "$branch" --json state -q '.state' 2>/dev/null)
        if [[ "$pr_state" == "MERGED" ]]; then
          status_info="[PR merged]"
          is_stale=true
        elif [[ "$pr_state" == "CLOSED" ]]; then
          status_info="[PR closed]"
          is_stale=true
        fi
      fi

      if [[ "$is_stale" == true ]]; then
        stale_worktrees+=("$wt_path")
        worktree_info+=("$wt_path	$branch	$status_info")
      fi
    fi
  done < <(git worktree list --porcelain)

  if [[ ${#stale_worktrees[@]} -eq 0 ]]; then
    echo "No stale worktrees found."
    return 0
  fi

  echo "Found ${#stale_worktrees[@]} stale worktree(s):"
  echo ""

  local selected_worktrees=()

  if [[ "$remove_all" == true ]]; then
    selected_worktrees=("${stale_worktrees[@]}")
    for info in "${worktree_info[@]}"; do
      echo "  $info"
    done
  else
    # Use fzf for selection
    local selected
    selected=$(printf '%s\n' "${worktree_info[@]}" | fzf --multi --header="Select worktrees to remove (TAB to select, ENTER to confirm)")

    if [[ -z "$selected" ]]; then
      echo "No worktrees selected."
      return 0
    fi

    while IFS= read -r line; do
      local wt_path
      wt_path=$(echo "$line" | cut -f1)
      selected_worktrees+=("$wt_path")
    done <<< "$selected"
  fi

  echo ""

  if [[ "$dry_run" == true ]]; then
    echo "Dry run - would remove:"
    for wt in "${selected_worktrees[@]}"; do
      echo "  git worktree remove $wt"
    done
    return 0
  fi

  # Remove selected worktrees
  local removed=0
  for wt in "${selected_worktrees[@]}"; do
    echo "Removing worktree: $wt"
    if git worktree remove "$wt" 2>/dev/null; then
      ((removed++))
    else
      echo "  Warning: Failed to remove $wt (trying with --force)"
      if git worktree remove --force "$wt" 2>/dev/null; then
        ((removed++))
      else
        echo "  Error: Could not remove $wt"
      fi
    fi
  done

  echo ""
  echo "Removed $removed worktree(s)."

  # Prune stale worktree references
  git worktree prune
}

make_or_cd_repo_path() {
  set -o pipefail
  path_to_repo=$(echo "$1" |
    sed -E 's/^(http(s)?\:\/\/|git)@?//' |
    sed -E 's/.git$//' |
    sed -E 's/:/\//')
  repo_path="$HOME/src/$path_to_repo"
  mkdir -p "$repo_path"
  cd "$repo_path" || return
  pwd
}

clone() {
  set -o pipefail
  if [[ $# -ne 1 ]]; then
    echo "Usage: gcl <git URL>"
    return 1
  fi
  repo_path=$(make_or_cd_repo_path "$1")
  cd "$repo_path" || return
  if [[ -d "$repo_path/.git" ]]; then
    echo "$repo_path already exists"
  else
    git clone "$1" "$repo_path"
  fi
}

pr_review() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: pr_review <pull request ID>"
    return 1
  else
    git diff-index --quiet --cached HEAD &&
      git fetch origin "pull/$1/head:pr-$1" &&
      git checkout "pr-$1"
  fi
}

my_issues() {
  if [[ -z $GITHUB_USERNAME ]]; then
    echo "Please set GITHUB_USERNAME"
    return 1
  else
    hub issue --creator="$GITHUB_USERNAME" --include-pulls
  fi
}

my_pull_requests() {
  if [[ -z $GITHUB_USERNAME ]]; then
    echo "Please set GITHUB_USERNAME"
    return 1
  else
    hub browse -- "pulls/$GITHUB_USERNAME"
  fi
}

deploy_current_branch_to_staging() {
  remote_name="$(git remote | grep -E 'staging' | fzf)"
  expected_pattern='^staging'
  if [[ "$remote_name" =~ $expected_pattern ]]; then
    echo Deploying "$(current_branch)" to "$(git remote get-url "$remote_name")"
    git push "$remote_name" "+$(current_branch):master"
  else
    echo "Remote did not match expected pattern"
    return 1
  fi
}
