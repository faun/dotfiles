#!/usr/bin/env bash

pip_packages=(
	black
	cmakelang
	djlint
	isort
	pynvim
	semgrep
	yamllint
	proselint
)
for egg in "${pip_packages[@]}"; do
	echo "Installing egg: $egg"
	pip3 install "$egg"
done
