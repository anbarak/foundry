#!/bin/bash
#
# Brave unpacked extensions installer
#
# Workaround for Zscaler TLS interception breaking Chrome Web Store installs
# in Brave. Downloads .crx files via curl (which trusts the Zscaler CA bundle),
# extracts them, and prepares them for "Load unpacked" in brave://extensions.
#
# Usage:
#   ./install.sh           # install all extensions
#   ./install.sh list      # print the extension registry
#   ./install.sh install <name>  # install a single extension by name
#   ./install.sh update    # re-download all extensions (for updates)
#
# After install, load each folder under $EXT_DIR via:
#   brave://extensions → Developer mode ON → Load unpacked → pick folder
#

set -euo pipefail

# ─── Configuration ──────────────────────────────────────────────────────────

EXT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/brave-extensions"

# Extension registry — edit this list, everything else follows.
# Format: "name:extension_id"
# Extension IDs come from the Chrome Web Store URL or chrome://extensions.
EXTENSIONS=(
  # Password manager
  "bitwarden:nngceckbapebfimnlniiiahkandclblb"
  "keeper:bfogiafebfohielmmehodmfbbebbbpei"

  # AI & productivity
  "claude:fcoeoabgfenejglbffodgkkbkcdhcgfn"
  "languagetool:oldceeleldhonbafppcapldpdifcinji"

  # Developer & design tools
  "colorzilla:bhlhnicpbhignbdhedgjhgdocnmhomnp"
  "display-anchors:poahndpaaanbpbeafbkploiobpiiieko"
  "gofullpage:fdpohaocaechififmbbbbbknoalclacl"
  "tampermonkey:dhdgffkkebhmkfjojejmpbldmpobfkfo"

  # Tab & session management
  "auto-tab-discard:jhnleheckmknfcgijgkadoemagpecfol"
  "tab-manager-workona:ailcmbgekjpnablpdkmaaccecekgdhlh"
  "tab-session-manager:iaiomicjabeggjcfkbimgmglanimpnae"

  # Media & content
  "enhancer-for-youtube:ponfpcnoihfmfllpaingbgckeeldkhle"
  "google-docs-offline:ghbmnnjooekpmoecnnnilnnbdlolhkhi"
  "rss-feed-reader:pnjaodmkngahhkoihejjehlcdlnohgmp"
  "qr-code-generator:afpbjjgbdimpioenaedcjgkaigggcdpp"
)

# ─── Helpers ────────────────────────────────────────────────────────────────

CRX_URL_TEMPLATE="https://clients2.google.com/service/update2/crx?response=redirect&os=mac&arch=x86-64&os_arch=x86-64&nacl_arch=x86-64&prod=chromiumcrx&prodchannel=stable&prodversion=135.0.0.0&lang=en-US&acceptformat=crx3&x=id%3D__ID__%26installsource%3Dondemand%26uc"

die() {
  echo "error: $*" >&2
  exit 1
}

check_deps() {
  command -v curl >/dev/null || die "curl not found"
  command -v python3 >/dev/null || die "python3 not found"
  command -v unzip >/dev/null || die "unzip not found"
}

list_extensions() {
  printf "%-28s %s\n" "NAME" "ID"
  printf "%-28s %s\n" "----" "--"
  for entry in "${EXTENSIONS[@]}"; do
    name="${entry%%:*}"
    id="${entry##*:}"
    printf "%-28s %s\n" "$name" "$id"
  done
}

install_one() {
  local name="$1"
  local id="$2"
  local url="${CRX_URL_TEMPLATE//__ID__/$id}"
  local crx="/tmp/${name}.crx"
  local target_dir="$EXT_DIR/$name"
  local max_attempts=3
  local attempt=1

  echo "→ $name ($id)"

  # Download with retries — Zscaler interception can return empty responses transiently
  while [ $attempt -le $max_attempts ]; do
    rm -f "$crx"
    if curl -sL -f -o "$crx" "$url" && [ -s "$crx" ]; then
      if file "$crx" | grep -q "Google Chrome extension"; then
        break
      fi
    fi
    if [ $attempt -lt $max_attempts ]; then
      echo "  ⟳ attempt $attempt failed, retrying..."
      sleep 2
    fi
    attempt=$((attempt + 1))
  done

  # Final validation
  if [ ! -s "$crx" ]; then
    echo "  ✗ download failed after $max_attempts attempts (empty response)"
    return 1
  fi
  if ! file "$crx" | grep -q "Google Chrome extension"; then
    echo "  ✗ downloaded file is not a valid .crx after $max_attempts attempts"
    echo "    (first line: $(head -c 80 "$crx"))"
    rm -f "$crx"
    return 1
  fi

  # Extract zip payload from CRX3 wrapper
  rm -rf "$target_dir"
  mkdir -p "$target_dir"

  python3 - "$crx" "$target_dir/extension.zip" <<'PY'
import struct, sys
src, dst = sys.argv[1], sys.argv[2]
with open(src, 'rb') as f:
    data = f.read()
magic = data[0:4]
if magic != b'Cr24':
    raise SystemExit(f"not a CRX file: magic={magic!r}")
version = struct.unpack('<I', data[4:8])[0]
if version == 2:
    pubkey_len = struct.unpack('<I', data[8:12])[0]
    sig_len = struct.unpack('<I', data[12:16])[0]
    zip_start = 16 + pubkey_len + sig_len
elif version == 3:
    header_len = struct.unpack('<I', data[8:12])[0]
    zip_start = 12 + header_len
else:
    raise SystemExit(f"unsupported CRX version: {version}")
with open(dst, 'wb') as out:
    out.write(data[zip_start:])
PY

  # Unzip and clean up
  (cd "$target_dir" && unzip -o -q extension.zip && rm extension.zip)
  rm -f "$crx"

  if [ ! -f "$target_dir/manifest.json" ]; then
    echo "  ✗ no manifest.json after extraction"
    return 1
  fi

  echo "  ✓ installed → $target_dir"
}

install_all() {
  mkdir -p "$EXT_DIR"
  local failed=()
  for entry in "${EXTENSIONS[@]}"; do
    name="${entry%%:*}"
    id="${entry##*:}"
    if ! install_one "$name" "$id"; then
      failed+=("$name")
    fi
  done

  echo
  echo "Done. Total: ${#EXTENSIONS[@]}, failed: ${#failed[@]}"
  if [ "${#failed[@]}" -gt 0 ]; then
    echo "Failed extensions: ${failed[*]}"
    exit 1
  fi

  echo
  echo "Next steps:"
  echo "  1. Open Brave → brave://extensions"
  echo "  2. Enable 'Developer mode' (top right)"
  echo "  3. For each extension folder, click 'Load unpacked' and select:"
  echo "       $EXT_DIR/<name>/"
}

install_by_name() {
  local target="$1"
  for entry in "${EXTENSIONS[@]}"; do
    name="${entry%%:*}"
    id="${entry##*:}"
    if [ "$name" = "$target" ]; then
      mkdir -p "$EXT_DIR"
      install_one "$name" "$id"
      return
    fi
  done
  die "unknown extension: $target (run './install.sh list' to see registry)"
}

# ─── Main ───────────────────────────────────────────────────────────────────

check_deps

case "${1:-install}" in
  list)
    list_extensions
    ;;
  install|update)
    if [ $# -ge 2 ]; then
      install_by_name "$2"
    else
      install_all
    fi
    ;;
  *)
    echo "usage: $0 [list|install [name]|update]"
    exit 1
    ;;
esac
