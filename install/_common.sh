#!/usr/bin/env bash
# Shared helpers for install/ steps. This file is sourced, not run directly,
# and is intentionally non-executable so install.sh's step discovery (which
# only picks up executable *.sh files in this directory) skips it.

detect_linux_package_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    echo apt-get
  elif command -v dnf >/dev/null 2>&1; then
    echo dnf
  elif command -v yum >/dev/null 2>&1; then
    echo yum
  fi
}

linux_pkg_installed() {
  local pm="$1" pkg="$2"
  case "$pm" in
    apt-get) dpkg -s "$pkg" >/dev/null 2>&1 ;;
    dnf | yum) rpm -q "$pkg" >/dev/null 2>&1 ;;
  esac
}

# linux_pkg_ensure <package-manager> <package>
# Installs <package> with <package-manager> unless already installed.
# Tolerates failure (e.g. a package missing from that distro's repos) so one
# bad package doesn't abort the rest of the run.
linux_pkg_ensure() {
  local pm="$1" pkg="$2"

  if linux_pkg_installed "$pm" "$pkg"; then
    echo "Package $pkg already installed"
    return 0
  fi

  echo "Installing package: $pkg"
  if ! sudo "$pm" install -y "$pkg" 2>/tmp/linux_package_error; then
    echo "Package $pkg failed to install!"
    echo ---
    cat /tmp/linux_package_error
    echo ---
  fi
}
