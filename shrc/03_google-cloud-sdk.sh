(which brew >/dev/null 2>&1) && {
  HOMEBREW_PATH=$(brew --prefix)
  if [[ -d "$HOMEBREW_PATH/Caskroom/google-cloud-sdk/latest/" ]]
  then
    if [[ -n $ZSH_NAME ]]
    then
      source "$HOMEBREW_PATH/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
      source "$HOMEBREW_PATH/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
    else
      source "$HOMEBREW_PATH/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
      source "$HOMEBREW_PATH/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
    fi
  fi
}
