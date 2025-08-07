#!/bin/bash

# This script outputs workspace information as a single line of JSON
# for eww to consume.

# Function to output workspace data
function get_workspaces {
    # Get all workspaces from sway
    local workspaces=$(swaymsg -t get_workspaces)

    # Get all open windows and find their parent workspace name
    local windows=$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.type=="con" or .type=="floating_con") | .workspace.name' | sort -u)

    # Combine the data into the desired JSON format
    echo "$workspaces" | jq --argjson windows "$(echo "$windows" | jq -R . | jq -s .)" '
        map({
            "name": .name,
            "status": if .focused then "active"
                      elif ($windows | index(.name)) then "occupied"
                      else "empty" end
        })
    ' | jq -c . # -c outputs a compact, single line
}

# Initial output
get_workspaces

# Subscribe to sway workspace events and re-run the function on each event
swaymsg -t subscribe -m '["workspace"]' | while read -r line; do
    get_workspaces
done
