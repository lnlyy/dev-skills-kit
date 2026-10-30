#!/usr/bin/env bash
set -euo pipefail
REPO="yvgude/lean-ctx"
INSTALL_DIR="${HOME}/.local/bin"
VERSION="3.12.0"
PLATFORM="aarch64-apple-darwin"
ASSET="lean-ctx-${PLATFORM}"
URL="https://github.com/${REPO}/releases/download/v${VERSION}/${ASSET}.tar.gz"

echo "Downloading lean-ctx v${VERSION} for ${PLATFORM}..."
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -fsSL "$URL" -o "${tmp}/lean-ctx.tar.gz"
tar -xzf "${tmp}/lean-ctx.tar.gz" -C "$tmp"
mkdir -p "$INSTALL_DIR"
mv "${tmp}/lean-ctx" "${INSTALL_DIR}/lean-ctx"
chmod +x "${INSTALL_DIR}/lean-ctx"
echo "Installed to ${INSTALL_DIR}/lean-ctx"

# PATH
case ":${PATH}:" in
    *":${INSTALL_DIR}:"*) ;;
    *) export PATH="${INSTALL_DIR}:${PATH}"
       echo "Add to ~/.zshrc: export PATH=\"${INSTALL_DIR}:\$PATH\""
esac
lean-ctx init --global 2>/dev/null || true
lean-ctx doctor --fix 2>/dev/null || true
echo "✅ Done"

