#!/bin/bash
# Check if wf-recorder is running
if pgrep -x "wf-recorder" > /dev/null; then
    # Stop recording gracefully
    pkill -INT -x "wf-recorder"
    notify-send "Screen Recorder" "Recording stopped"
else
    # Start recording and save to Videos folder with timestamp
    # Add -g "$(slurp)" if you want to select a region instead of full screen
    wf-recorder -f "$HOME/Videos/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4" &
    notify-send "Screen Recorder" "Recording started"
fi
