#!/bin/sh

# Get the current window ID
current_window_id=$(yabai -m query --windows --window | jq -r '.id')

# Get the ID of the current space

# Debug output
echo "Current Window ID: $current_window_id"

# Get the IDs of all visible windows in the current space
windows=$(yabai -m query --windows | jq -r '
    .[] |
    select(.["is-visible"] == true) |
    .id')

# Debug output
echo "Visible Windows: $windows"

# Convert window IDs to an array
windows_array=($windows)

# Check if there are any windows in the array
if [ ${#windows_array[@]} -eq 0 ]; then
    echo "No visible windows to cycle through."
    exit 1
fi

# Find the index of the current window
current_index=$(echo "${windows_array[@]}" | tr ' ' '\n' | grep -n "^$current_window_id$" | cut -d: -f1)

# Debug output
echo "Current Index: $current_index"

# If the current window is not in the list, start from the first window
if [ -z "$current_index" ]; then
    next_index=0
else
    # Calculate the index of the next window
    next_index=$(( (current_index + 1) % ${#windows_array[@]} ))
fi

# Focus the next window
next_window_id=${windows_array[$next_index]}
echo "Focusing Window ID: $next_window_id"
yabai -m window --focus "$next_window_id"
