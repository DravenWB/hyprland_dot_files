#!/bin/bash

# Screenshot output path
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# Timestamped filename
FILENAME="$DIR/screenshot-$(date +'%Y%m%d-%H%M%S').png"

# Take screenshot using slurp + grim
slurp | grim -g - "$FILENAME"

# Copy to clipboard using wl-copy
wl-copy < "$FILENAME"

# Notify (optional)
notify-send "Screenshot Taken" "$FILENAME copied to clipboard"
