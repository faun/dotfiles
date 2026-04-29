#!/usr/bin/env bash

set -eou pipefail

cd "$(dirname "$0")" || exit 1

eval "$(mise activate bash)"

GOPROXY="${GOPROXY:-https://proxy.golang.org,direct}"
export GOPROXY

go_modules=(
  github.com/nametake/golangci-lint-langserver
  golang.org/x/tools/gopls
  mvdan.cc/sh/v3/cmd/shfmt
  github.com/golangci/golangci-lint/cmd/golangci-lint
  mvdan.cc/gofumpt
  golang.org/x/tools/cmd/goimports
  github.com/cweill/gotests/gotests
  golang.org/x/vuln/cmd/govulncheck
  github.com/moznion/gojsonstruct/cmd/gojsonstruct
  gotest.tools/gotestsum
  golang.org/x/tools/cmd/callgraph
  github.com/koron/iferr
  github.com/haya14busa/goplay/cmd/goplay
  github.com/josharian/impl
  github.com/abenz1267/gomvp
  github.com/davidrjenni/reftools/cmd/fillswitch
  github.com/dmarkham/enumer
  github.com/google/gonew
  github.com/vektra/mockgen/v2/cmd/mockgen
  github.com/kyoh86/richgo
)

for module in "${go_modules[@]}"; do
  echo "Installing module: $module"
  set +e
  go install "$module"@latest 2>/tmp/go_module_error
  status=$?
  set -e
  if [[ $status != 0 ]]; then
    echo "Package $module failed to install!"
    echo ---
    cat /tmp/go_module_error
    echo ---
  fi
done
