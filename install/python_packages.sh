#!/usr/bin/env bash

pip_packages=(
	yamllint
	pynvim
	djlint
	black
	isort
	cmakelang
)
for egg in "${pip_packages[@]}"; do
	echo "Installing egg: $egg"
	pip3 install "$egg"
done
