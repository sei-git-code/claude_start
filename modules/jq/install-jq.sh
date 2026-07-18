#!/usr/bin/env bash
# jq をOSに応じて自動インストールする（statusline / hookスクリプトの依存）
set -uo pipefail

if command -v jq >/dev/null 2>&1; then
  echo "jq already installed: $(jq --version)"
  exit 0
fi

os="$(uname -s)"
case "$os" in
  Darwin*)              platform="mac" ;;
  MINGW*|MSYS*|CYGWIN*)  platform="windows" ;;
  Linux*)                platform="linux" ;;
  *)                     platform="unknown" ;;
esac

case "$platform" in
  windows)
    if command -v winget >/dev/null 2>&1; then
      winget install jqlang.jq --accept-source-agreements --accept-package-agreements
    else
      echo "winget not found. Install jq manually: https://jqlang.org/download/" >&2
      exit 1
    fi
    ;;
  mac)
    if command -v brew >/dev/null 2>&1; then
      brew install jq
    else
      echo "Homebrew not found. Install it from https://brew.sh, then run: brew install jq" >&2
      exit 1
    fi
    ;;
  linux)
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update && sudo apt-get install -y jq
    elif command -v dnf >/dev/null 2>&1; then
      sudo dnf install -y jq
    elif command -v pacman >/dev/null 2>&1; then
      sudo pacman -S --noconfirm jq
    else
      echo "No known package manager found. Install jq manually: https://jqlang.org/download/" >&2
      exit 1
    fi
    ;;
  *)
    echo "Unknown platform; install jq manually: https://jqlang.org/download/" >&2
    exit 1
    ;;
esac
