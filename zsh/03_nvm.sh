record_time "source nvm"
# shellcheck source=../../../../../.nvm/nvm.sh
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
# shellcheck source=../../../../../.nvm/bash_completion
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

record_time "nvm autoloading"
# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use > /dev/null
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
