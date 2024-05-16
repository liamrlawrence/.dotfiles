#!/bin/bash


SOFTWARE_DIR="$HOME/Software"
ASSET_NAME="nvim-linux64"
ASSET_TAR="$ASSET_NAME.tar.gz"
CHECKSUM="$ASSET_TAR.sha256sum"


TMP_DIR=$(mktemp -d)
LATEST_RELEASE_URL="https://api.github.com/repos/neovim/neovim/releases/latest"
LATEST_RELEASE=$(wget -qO- "$LATEST_RELEASE_URL")

ASSET_URL=$(echo $LATEST_RELEASE | jq -r '.assets[] | select(.name == "'$ASSET_TAR'") | .browser_download_url')
SUM_URL=$(echo $LATEST_RELEASE | jq -r '.assets[] | select(.name == "'$CHECKSUM'") | .browser_download_url')


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

cd $TMP_DIR
download_file "$ASSET_URL" "$ASSET_TAR"
download_file "$SUM_URL" "$CHECKSUM"

if sha256sum -c "$CHECKSUM"; then
    echo "Checksum verification passed for $ASSET_TAR"
else
    echo "Checksum verification failed for $ASSET_TAR"
    exit 1
fi

mkdir -p "$SOFTWARE_DIR"
if [ -d "$SOFTWARE_DIR/$ASSET_NAME" ]; then     # Remove old version if exists
    mv "$SOFTWARE_DIR/$ASSET_NAME" $TMP_DIR/
else
    echo "# Neovim" >> ~/.bashrc
    echo "alias vim=\"$SOFTWARE_DIR/$ASSET_NAME/bin/nvim\"" >> ~/.bashrc
    echo "export SUDO_EDITOR=\"$SOFTWARE_DIR/$ASSET_NAME/bin/nvim\"" >> ~/.bashrc
    echo "" >> ~/.bashrc
    echo "~/.bashrc has been updated"
fi

tar xfz $ASSET_TAR -C $SOFTWARE_DIR

