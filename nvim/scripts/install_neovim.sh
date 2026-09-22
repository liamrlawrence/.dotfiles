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
    echo "      --nightly      Install the latest nightly build instead of the latest stable release"
    echo
    echo "Examples:"
    echo "  $0"
    echo "  $0 --nightly"
    echo "  $0 --dir /usr/local"
    echo "  sudo -E $0 --dir /usr/local --nightly"
}

# ---- Parse args --------------------------------------------------------------
installation_dir="$DEFAULT_DIR"
channel="stable"

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
            --nightly)
                channel="nightly"
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
need tar

# Linux has sha256sum; macOS ships shasum instead.
if command -v sha256sum >/dev/null 2>&1; then
    sha256_of() { sha256sum "$1" | awk '{print $1}'; }
elif command -v shasum >/dev/null 2>&1; then
    sha256_of() { shasum -a 256 "$1" | awk '{print $1}'; }
else
    echo "Error: need either 'sha256sum' or 'shasum' to verify the download." >&2
    exit 1
fi


# ---- Config -----------------------------------------------------------------
os="$(uname -s)"
case "$os" in
    Linux)  platform="linux" ;;
    Darwin) platform="macos" ;;
    *)
        echo "Error: unsupported OS '$os' (this script handles Linux and macOS)." >&2
        exit 1
        ;;
esac

machine="$(uname -m)"
case "$machine" in
    x86_64|amd64)  arch="x86_64" ;;
    aarch64|arm64) arch="arm64" ;;
    *)
        echo "Error: no official Neovim build for architecture '$machine'." >&2
        echo "       Official builds exist for x86_64 and arm64 only." >&2
        exit 1
        ;;
esac

installation_name="nvim-$platform"             # final folder name after install
asset_name="nvim-$platform-$arch"
asset_tar="$asset_name.tar.gz"
echo "Detected platform: $os $machine -> $asset_tar"

# /releases/latest skips prereleases, so nightly has to be fetched by its tag.
if [[ "$channel" == "nightly" ]]; then
    release_url="https://api.github.com/repos/neovim/neovim/releases/tags/nightly"
else
    release_url="https://api.github.com/repos/neovim/neovim/releases/latest"
fi


# ---- Fetch release JSON -----------------------------------------------------
echo "Fetching $channel Neovim release metadata..."
release_json="$(curl --fail --silent --show-error -H "Accept: application/vnd.github+json" -L "$release_url")"

release_tag="$(echo "$release_json" | jq -r '.tag_name // "unknown"')"
release_date="$(echo "$release_json" | jq -r '.published_at // "unknown"')"
echo "Found release: $release_tag (published $release_date)"

asset_url="$(echo "$release_json" \
    | jq -r --arg asset "$asset_tar" '.assets[] | select(.name==$asset) | .browser_download_url // empty')"

if [[ -z "$asset_url" ]]; then
    echo "Error: could not find asset '$asset_tar' in the $channel release." >&2
    exit 1
fi

checksum="$(echo "$release_json" \
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
    actual="$(sha256_of "$asset_tar")"
    if [[ "$actual" == "$expected" ]]; then
        echo "Checksum verification passed for $asset_tar"
    else
        echo "Checksum verification FAILED for $asset_tar" >&2
        echo "  expected: $expected" >&2
        echo "  actual:   $actual" >&2
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

# Make sure the new binary actually runs here before touching the current install
new_nvim="$installation_dir/$asset_name/bin/nvim"
if ! version_output="$("$new_nvim" --version 2>&1)"; then
    echo "Error: the downloaded nvim won't run on this machine:" >&2
    echo "  $version_output" >&2
    echo "Removing $installation_dir/$asset_name; existing install left untouched." >&2
    rm -rf "${installation_dir:?}/$asset_name"
    exit 1
fi
new_version="${version_output%%$'\n'*}"

# Normalize directory name to a stable path
if [[ -d "$installation_dir/$installation_name" ]]; then
    backup_install="$installation_dir/${installation_name}.bak.$(date +%s)"
    echo "Found existing $installation_dir/$installation_name — moving to $backup_install"
    mv "$installation_dir/$installation_name" "$backup_install"
fi
mv "$installation_dir/$asset_name" "$installation_dir/$installation_name"

echo "Neovim ($channel) installed: $new_version"

