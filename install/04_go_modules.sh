#!/usr/bin/env bash

GOPROXY="${GOPROXY:-https://proxy.golang.org,direct}"
export GOPROXY

set -e

go_modules=(
	github.com/nametake/golangci-lint-langserver
	golang.org/x/tools/gopls
	mvdan.cc/sh/v3/cmd/shfmt
	github.com/golangci/golangci-lint/cmd/golangci-lint
	mvdan.cc/gofumpt
	golang.org/x/tools/cmd/goimports
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
