#!/bin/bash

STATE_FILE="/home/daarkblood/.config/scripts/state-cache/audio-output.state"

# Define sink keys
HEADPHONES_KEY="alsa_output.usb-Focusrite_Scarlett_Solo_USB-00.pro-output-0"
SPEAKERS_KEY="alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink"

# Get current default sink
CURRENT_SINK=$(pactl get-default-sink)

# Determine current state and write to file
if [[ "$CURRENT_SINK" == "$HEADPHONES_KEY" ]]; then
    echo -n "1" > "$STATE_FILE"
else
    echo -n "0" > "$STATE_FILE"
fi
