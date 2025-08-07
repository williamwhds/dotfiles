#!/bin/bash

# This script gets the raw workspace data from sway and sorts it numerically.
get_workspaces_info() {
    swaymsg -t get_workspaces | jq 'sort_by(.name | tonumber)'
}

# Initial output
get_workspaces_info

# Subscribe to workspace events and re-run the function on each event.
# The "-m" flag is the correct one for monitoring.
swaymsg -t subscribe -m '["workspace"]' | while read -r event; do
    get_workspaces_info
done
