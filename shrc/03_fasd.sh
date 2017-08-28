
configure_fasd() {
  [[ "$(command -v fasd)" ]] || return
  if [[ -n $ZSH_NAME ]]
  then
    fasd_cache="$HOME/.fasd-init-zsh"
    if [ "$(command -v fasd)" -nt "$fasd_cache" ] || [ ! -s "$fasd_cache" ]; then
      fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
    fi

    alias v='f -t -e vim -b viminfo'
  else
    fasd_cache="$HOME/.fasd-init-bash"
    if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
      fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
    fi
  fi
  source "$fasd_cache"
  unset fasd_cache
}

configure_fasd

record_time "fasd"
