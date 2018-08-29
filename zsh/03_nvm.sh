if [[ -d "$NVM_DIR" ]]
then
  # shellcheck source=../../../../../.nvm/nvm.sh
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
  record_time "source nvm"
  # shellcheck source=../../../../../.nvm/bash_completion
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  record_time "nvm completion"

  # place this after nvm initialization!
  autoload -U add-zsh-hook
  load-nvmrc() {
    node_version="$(nvm version)"
    local node_version
    nvmrc_path="$(nvm_find_nvmrc)"
    local nvmrc_path

    if [ -n "$nvmrc_path" ]; then
      nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
      local nvmrc_node_version

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use > /dev/null
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default > /dev/null
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  # load-nvmrc
  record_time "nvm autoloading"
fi
