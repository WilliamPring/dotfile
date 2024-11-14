#!/bin/bash

# Define source and destination for dotfiles
SOURCE_CONFIG_DIR="$HOME/.config"  # .config directory as source
SOURCE_HOME_DIR="$HOME"  # Home directory as source
DEST_CONFIG_DIR="$HOME/repos/dotfile/.config"  # Destination directory for .config files
DEST_HOME_DIR="$HOME/repos/dotfile/.config-home"  # Destination directory for home directory files


# List of directories to be copied from ~/.config
CONFIG_ITEMS=("keyboard" "newsboat" "rofi" "starship.toml" "i3" "i3status" "ranger" "audio-mapper.carxp")

# List of files to be copied from ~ (home directory)
HOME_FILES=(".zshrc" ".vimrc" ".Xauthority" ".xinitrc" ".Xresources")


# Function to sync dotfiles from ~/.config to the repo
SYNC_CONFIG_DOTFILES() {
    echo "Syncing dotfiles from .config..."
    for ITEM in "${CONFIG_ITEMS[@]}"; do
        SOURCE_PATH="$SOURCE_CONFIG_DIR/$ITEM"
        DEST_PATH="$DEST_CONFIG_DIR/$ITEM"
        
        if [ -d "$SOURCE_PATH" ]; then
            # If it's a directory, copy recursively
            echo "Copying directory $ITEM..."
            cp -r "$SOURCE_PATH" "$DEST_PATH"
        elif [ -f "$SOURCE_PATH" ]; then
            # If it's a file, copy normally
            echo "Copying file $ITEM..."
            cp "$SOURCE_PATH" "$DEST_PATH"
        else
            echo "$ITEM does not exist in the source directory."
        fi
    done
}

# Function to sync dotfiles from ~ (home directory) to the repo
SYNC_HOME_DOTFILES() {
    echo "Syncing dotfiles from home directory..."
    for ITEM in "${HOME_FILES[@]}"; do
        SOURCE_PATH="$SOURCE_HOME_DIR/$ITEM"
        DEST_PATH="$DEST_HOME_DIR/$ITEM"
        
        if [ -f "$SOURCE_PATH" ]; then
            # If it's a file, copy normally
            echo "Copying file $ITEM..."
            cp "$SOURCE_PATH" "$DEST_PATH"
        else
            echo "$ITEM does not exist in the source directory."
        fi
    done
}

SYNC_CONFIG_DOTFILES
SYNC_HOME_DOTFILES

echo "Sync completed."
