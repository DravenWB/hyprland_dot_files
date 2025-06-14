#!/bin/bash

STATE_FILE="/home/$USER/.config/scripts/state-cache/audio-output.state"

HEADPHONES_KEY="alsa_output.usb-Focusrite_Scarlett_Solo_USB-00.pro-output-0"
SPEAKERS_KEY="alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink"

HEADPHONES_SINK=$(pactl list short sinks | grep "$HEADPHONES_KEY" | awk '{print $2}')
SPEAKERS_SINK=$(pactl list short sinks | grep "$SPEAKERS_KEY" | awk '{print $2}')

# Create file if missing
if [[ ! -f "$STATE_FILE" ]]; then
    echo -n "0" > "$STATE_FILE"
fi

# If called with --status, just report the icon/tooltip
if [[ "$1" == "--status" ]]; then
    STATE=$(<"$STATE_FILE")
    if [[ "$STATE" == "1" ]]; then
        ICON="🎧"
        DESC="Scarlett Solo Headphones"
    elif [[ "$STATE" == "0" ]]; then
        ICON="🔊"
        DESC="USB Speakers"
    else
        ICON="🔇"
        DESC="Unknown Output"
    fi
    echo "{\"text\": \"$ICON\", \"tooltip\": \"$DESC\"}"
    exit 0
fi

# Read current state and toggle
STATE=$(<"$STATE_FILE")

if [[ "$STATE" == "1" ]]; then
    TARGET="$SPEAKERS_SINK"
    LABEL="Speakers"
    NEW_STATE="0"
else
    TARGET="$HEADPHONES_SINK"
    LABEL="Headphones"
    NEW_STATE="1"
fi

# Switch sinks
pactl set-default-sink "$TARGET"

# Move all audio streams to the new sink
for INPUT in $(pactl list short sink-inputs | awk '{print $1}'); do
    pactl move-sink-input "$INPUT" "$TARGET"
done

# Update state file
echo -n "$NEW_STATE" > "$STATE_FILE"

notify-send "Switched to $LABEL"
