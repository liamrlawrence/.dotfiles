#!/bin/bash

set -euo pipefail

DEFAULT_DIR="$HOME/Software"

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Install the latest version of Neovim."
    echo
    echo "Options:"
    echo "  -h, --help         Show this help message and exit"
    echo "      --dir PATH     Installation directory (default: '$DEFAULT_DIR')"
    echo
    echo "Examples:"
    echo "  $0"
    echo "  $0 --dir /usr/local"
    echo "  sudo -E $0 --dir /usr/local"
}

# ---- Parse args --------------------------------------------------------------
installation_dir="$DEFAULT_DIR"

if [[ $# -gt 0 ]]; then
    while [[ $# -gt 0 ]]; do
        case "${1-}" in
            -h|--help)
                show_help
                exit 0
                ;;
            --dir)
                shift
                if [[ $# -eq 0 ]]; then
                    echo "Error: --dir requires a PATH argument." >&2
                    exit 1
                fi
                installation_dir="$1"
                shift
                ;;
            --)
                shift
                break
                ;;
            -*)
                echo "Error: unknown option '$1'" >&2
                echo "Try: $0 --help" >&2
                exit 1
                ;;
            *)
                echo "Error: positional arguments are not supported. Use --dir PATH." >&2
                exit 1
                ;;
        esac
    done
fi


# ---- Requirements ------------------------------------------------------------
need() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Error: required command '$1' not found." >&2
        exit 1
    }
}
need curl
need jq
need sha256sum
need tar


# ---- Config -----------------------------------------------------------------
installation_name="nvim-linux"                 # final folder name after install
asset_name="nvim-linux-x86_64"
asset_tar="$asset_name.tar.gz"

latest_release_url="https://api.github.com/repos/neovim/neovim/releases/latest"


# ---- Fetch release JSON -----------------------------------------------------
echo "Fetching latest Neovim release metadata..."
latest_json="$(curl --fail --silent --show-error -H "Accept: application/vnd.github+json" -L "$latest_release_url")"

asset_url="$(echo "$latest_json" \
    | jq -r --arg asset "$asset_tar" '.assets[] | select(.name==$asset) | .browser_download_url // empty')"

if [[ -z "$asset_url" ]]; then
    echo "Error: could not find asset '$asset_tar' in the latest release." >&2
    exit 1
fi

checksum="$(echo "$latest_json" \
    | jq -r --arg asset "$asset_tar" '.assets[] | select(.name==$asset) | .digest // empty')"

if [[ -n "$checksum" && "$checksum" != sha256:* ]]; then
    echo "Warning: unexpected digest format: '$checksum' (expected 'sha256:<hex>')" >&2
fi


# ---- Download ---------------------------------------------------------------
tmp_dir="$(mktemp -d)"
cleanup() {
    rm -rf "$tmp_dir"
}
trap cleanup EXIT

cd "$tmp_dir"
echo "Downloading: $asset_url"
curl --fail --silent --show-error -L -o "$asset_tar" "$asset_url"


# ---- Verify (if digest available) -------------------------------------------
if [[ -n "${checksum:-}" && "$checksum" == sha256:* ]]; then
    expected="${checksum#sha256:}"
    echo "Verifying checksum (sha256)..."
    # Use --check format: "<hash><two spaces><filename>"
    if printf '%s  %s\n' "$expected" "$asset_tar" | sha256sum --check --status -; then
        echo "Checksum verification passed for $asset_tar"
    else
        echo "Checksum verification FAILED for $asset_tar" >&2
        exit 1
    fi
else
    echo "Note: No GitHub-provided digest available for this asset. Skipping verification."
fi


# ---- Install ---------------------------------------------------------------
echo "Installing to: $installation_dir"
mkdir -p "$installation_dir"

# Backup any existing extracted dir before untar
if [[ -d "$installation_dir/$asset_name" ]]; then
    backup_dir="$installation_dir/${asset_name}.bak.$(date +%s)"
    echo "Found existing $installation_dir/$asset_name — moving to $backup_dir"
    mv "$installation_dir/$asset_name" "$backup_dir"
fi

tar xfz "$asset_tar" -C "$installation_dir"

# Normalize directory name to a stable path
if [[ -d "$installation_dir/$installation_name" ]]; then
    backup_install="$installation_dir/${installation_name}.bak.$(date +%s)"
    echo "Found existing $installation_dir/$installation_name — moving to $backup_install"
    mv "$installation_dir/$installation_name" "$backup_install"
fi
mv "$installation_dir/$asset_name" "$installation_dir/$installation_name"

echo "Neovim installed."

