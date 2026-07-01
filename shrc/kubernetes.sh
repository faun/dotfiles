#!/usr/bin/env bash

# Kubernetes aliases and functions

alias k="kubectl"
alias kctx='kubectx'
alias kns='kubens "$(namespace_options)"'
alias ktx='kubectx "$(context_options)"'
alias kcistio=kcin

kcontext() {
  kubectl config use-context "$(kubectl config get-contexts -o name | fzf)"
}

current_namespace() {
  local cur_ctx
  cur_ctx="$(current_context)"
  ns="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${cur_ctx}\")].context.namespace}")"
  if [[ -z "${ns}" ]]; then
    echo "default"
  else
    echo "${ns}"
  fi
}

current_context() {
  kubectl config view -o=jsonpath='{.current-context}'
}

strip_ansi() {
  if command -v strip-ansi >/dev/null 2>&1; then
    strip-ansi
  else
    npx strip-ansi-cli 2>/dev/null
    npm install --global strip-ansi-cli >/dev/null 2>&1 &
  fi
}

namespace_options() {
  kubens | strip_ansi | fzf || current_namespace
}

context_options() {
  kubectx | strip_ansi | fzf || current_context
}

kcapp() {
  if [[ $# -ne 1 ]]; then
    echo "Usage kcapp <app_label>"
    return 1
  fi

  kubectl get pod -l app="$1" \
    --sort-by=.status.startTime \
    --field-selector=status.phase=Running \
    -o=jsonpath='{.items[-1:].metadata.name}' |
    tail -1
}

kcin() {
  if [[ $# -ne 1 ]]; then
    echo "Usage kcin <istio_label>"
    return 1
  fi

  kubectl get -n istio-system pod -l istio="$1" \
    -o=jsonpath='{.items[-1:].metadata.name}'
}

kcimt() {
  if [[ $# -ne 1 ]]; then
    echo "Usage kcimt <istio-mixer-type>"
    return 1
  fi

  kubectl get -n istio-system pod -l istio-mixer-type="$1" \
    -o=jsonpath='{.items[-1:].metadata.name}'
}

kcrelease() {
  if [[ $# -ne 1 ]]; then
    echo "Usage kcrelease <release_label>"
    return 1
  fi

  kubectl get pods -l release="$1" \
    --sort-by=.status.startTime \
    --field-selector=status.phase=Running \
    -o=jsonpath='{.items[-1:].metadata.name}' |
    tail -1
}

kcrun() {
  if [[ $# -ne 1 ]]; then
    echo "Usage krun <run_label>"
    return 1
  fi

  kubectl get pod -l run="$1" \
    -o=jsonpath='{.items[-1:].metadata.name}' |
    tail -1
}

kcx() {
  if [[ $# -lt 3 ]]; then
    echo "Usage kcx <pod> <container> [commands]"
    return 1
  fi

  kubectl exec -it "$1" -c "$2" -- "${@:3}"
}
