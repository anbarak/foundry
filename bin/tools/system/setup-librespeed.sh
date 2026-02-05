#!/usr/bin/env bash
set -euo pipefail

echo "🌐 Installing librespeed-cli..."

# Detect OS and architecture
source "$HOME/bin/foundry/detect-os.sh"

# Detect architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
  PLATFORM="amd64"
elif [[ "$ARCH" == "arm64" ]] || [[ "$ARCH" == "aarch64" ]]; then
  PLATFORM="arm64"
else
  echo "❌ Unsupported architecture: $ARCH"
  exit 1
fi

# Determine OS name for download
case "$FOUNDRY_OS" in
  macos) OS_NAME="darwin" ;;
  wsl|linux) OS_NAME="linux" ;;
  *) echo "❌ Unsupported OS"; exit 1 ;;
esac

# Fetch the latest release version
LATEST_VERSION=$(curl -s https://api.github.com/repos/librespeed/speedtest-cli/releases/latest | jq -r .tag_name)
if [[ -z "${LATEST_VERSION:-}" || "$LATEST_VERSION" == "null" ]]; then
  echo "❌ Failed to fetch latest version from GitHub."
  exit 1
fi

# Construct real binary name
FILENAME="librespeed-cli_${LATEST_VERSION#v}_${OS_NAME}_${PLATFORM}.tar.gz"

# Define paths
DEST="$HOME/.local/bin/tools"
BIN="$DEST/librespeed-cli"
SYMLINK="$HOME/bin/librespeed"

mkdir -p "$DEST" "$HOME/bin"
TMP_DIR=$(mktemp -d)

# Download the correct release asset
echo "⬇️  Downloading version $LATEST_VERSION for $PLATFORM..."
curl -fLs "https://github.com/librespeed/speedtest-cli/releases/download/${LATEST_VERSION}/${FILENAME}" \
  -o "$TMP_DIR/librespeed.tar.gz"

# Extract and install
tar -xzf "$TMP_DIR/librespeed.tar.gz" -C "$TMP_DIR"
if [[ ! -f "$TMP_DIR/librespeed-cli" ]]; then
  echo "❌ Extracted binary not found. Something went wrong."
  ls -la "$TMP_DIR"
  exit 1
fi

mv "$TMP_DIR/librespeed-cli" "$BIN"
chmod +x "$BIN"
rm -rf "$TMP_DIR"

ln -sf "$BIN" "$SYMLINK"

echo "✅ librespeed-cli $LATEST_VERSION installed at: $BIN"
echo "➡️  Symlinked to: $SYMLINK"
echo "🧪 Try running: librespeed --simple"
