#!/usr/bin/env bash

set -euo pipefail

gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 0x7413A06D
curl https://mise.jdx.dev/install.sh.sig | gpg --decrypt >mise_install.sh

sh ./mise_install.sh
rm ./mise_install.sh
