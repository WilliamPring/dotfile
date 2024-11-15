#!/bin/bash

# Define source directories from the repository
SOURCE_CONFIG_DIR="$HOME/repos/dotfile/.config"  # Source directory for .config items
SOURCE_HOME_DIR="$HOME/repos/dotfile/.config-home"  # Source directory for home items

# Define target directories
TARGET_CONFIG_DIR="$HOME/.config"  # Target .config directory
TARGET_HOME_DIR="$HOME"  # Target home directory

# Restore function for ~/.config
RESTORE_CONFIG() {
    echo "Restoring .config files..."
    if [ -d "$SOURCE_CONFIG_DIR" ]; then
        for ITEM in "$SOURCE_CONFIG_DIR"/*; do
            ITEM_NAME=$(basename "$ITEM")
            DEST_PATH="$TARGET_CONFIG_DIR/$ITEM_NAME"
            
            # Copy the item (file or directory)
            if [ -d "$ITEM" ]; then
                echo "Restoring directory $ITEM_NAME to $TARGET_CONFIG_DIR..."
                cp -r "$ITEM" "$DEST_PATH"
            elif [ -f "$ITEM" ]; then
                echo "Restoring file $ITEM_NAME to $TARGET_CONFIG_DIR..."
                cp "$ITEM" "$DEST_PATH"
            fi
        done
    else
        echo "Source directory $SOURCE_CONFIG_DIR does not exist."
    fi
}

# Restore function for ~ (home directory files)
RESTORE_HOME() {
    echo "Restoring home directory files..."
    if [ -d "$SOURCE_HOME_DIR" ]; then
        for ITEM in "$SOURCE_HOME_DIR"/*; do
            ITEM_NAME=$(basename "$ITEM")
            DEST_PATH="$TARGET_HOME_DIR/$ITEM_NAME"
            
            # Copy the item (file only, assuming home files are flat files)
            if [ -f "$ITEM" ]; then
                echo "Restoring file $ITEM_NAME to $TARGET_HOME_DIR..."
                cp "$ITEM" "$DEST_PATH"
            fi
        done
    else
        echo "Source directory $SOURCE_HOME_DIR does not exist."
    fi
}

# Main function to handle the restoration process
MAIN() {
    RESTORE_CONFIG
    RESTORE_HOME
    echo "Restoration completed!"
}

# Run the main function
MAIN
