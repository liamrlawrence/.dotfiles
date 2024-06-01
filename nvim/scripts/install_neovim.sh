#!/bin/bash



DEFAULT_DIR="$HOME/Software"

show_help() {
    echo "Usage: $0 [OPTION] [DIR]"
    echo
    echo "Install the latest version of Neovim."
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo
    echo "DIR:"
    echo "  Optional pathstring to specify the installation directory."
    echo "  Default is '$DEFAULT_DIR' if not provided."
    echo
    echo "Example:"
    echo "sudo -E $0 /usr/local"
}
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

installation_dir="${1:-$DEFAULT_DIR}"


# Files
asset_name="nvim-linux64"
asset_tar="$asset_name.tar.gz"
checksum="$asset_tar.sha256sum"

# URLs
latest_release_url="https://api.github.com/repos/neovim/neovim/releases/latest"
latest_release=$(wget -qO- "$latest_release_url")
asset_url=$(echo $latest_release | jq -r '.assets[] | select(.name == "'$asset_tar'") | .browser_download_url')
sum_url=$(echo $latest_release | jq -r '.assets[] | select(.name == "'$checksum'") | .browser_download_url')


download_file() {
    local url=$1
    local output=$2
    if [ -n "$url" ]; then
        wget -q -O "$output" "$url"
        if [ $? -eq 0 ]; then
            echo "Downloaded $output from $url"
        else
            echo "Failed to download $output from $url"
            exit 1
        fi
    else
        echo "URL for $output not found"
        exit 1
    fi
}
tmp_dir=$(mktemp -d)
cd $tmp_dir
download_file "$sum_url" "$checksum"
download_file "$asset_url" "$asset_tar"


if sha256sum -c "$checksum"; then
    echo "Checksum verification passed for $asset_tar"
else
    echo "Checksum verification failed for $asset_tar"
    exit 1
fi


mkdir -p "$installation_dir"
if [ -d "$installation_dir/$asset_name" ]; then
    mv "$installation_dir/$asset_name" $tmp_dir/
fi
tar xfz "$asset_tar" -C "$installation_dir"


if [ -z "$NEOVIM_PATH" ]; then
    if [ -n "$SUDO_USER" ]; then
        USER_HOME="$(eval echo ~$SUDO_USER)"
    else
        USER_HOME="$HOME"
    fi
    bashrc_path="$USER_HOME/.bashrc"
    echo "# Neovim" >> "$bashrc_path"
    echo "export NEOVIM_PATH=\"$installation_dir/$asset_name/bin/nvim\"" >> "$bashrc_path"
    echo 'alias vim="$NEOVIM_PATH"' >> "$bashrc_path"
    echo 'export SUDO_EDITOR="$NEOVIM_PATH"' >> "$bashrc_path"
    echo "" >> "$bashrc_path"
    echo "$bashrc_path has been updated"
fi


echo "Neovim installed, run with 'vim'"

