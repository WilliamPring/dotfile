#!/bin/bash

SOURCE_DIR="$HOME/.config"  # .config directory as source
DEST_DIR="$HOME/repos/dotfile/.config"  # Destination directory

# Directories to be copied
ITEMS=("keyboard" "newsboat" "rofi" "starship.toml" "i3" "i3status" "i3status-rust" "ranger" "antigenrc" "antigenrc.zwc" "audio-mapper.carxp" "will-linux.qpwgraph")

# Loop through each item and copy it to the destination
for ITEM in "${ITEMS[@]}"; do
    SOURCE_PATH="$SOURCE_DIR/$ITEM"
    DEST_PATH="$DEST_DIR/$ITEM"
    
    if [ -d "$SOURCE_PATH" ]; then
        # If it's a directory, copy recursively
        echo "Copying directory $ITEM..."
        cp -r "$SOURCE_PATH" "$DEST_PATH"
    elif [ -f "$SOURCE_PATH" ]; then
        # If it's a file, copy normally
        echo "Copying file $ITEM..."
        cp "$SOURCE_PATH" "$DEST_PATH"
    else
        # If it's neither a file nor directory, print a message
        echo "$ITEM does not exist in the source directory."
    fi
done

echo "Sync completed."
