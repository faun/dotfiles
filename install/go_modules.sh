#!/usr/bin/env bash

set -e

go_modules=(
	github.com/nametake/golangci-lint-langserver
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
