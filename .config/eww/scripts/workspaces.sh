#!/bin/bash

# This script gets the entire sway layout tree and processes it in one go.

get_workspaces() {
    # Get the entire layout tree from sway
    tree=$(swaymsg -t get_tree)

    # Use jq to process this tree into the desired JSON format
    echo "$tree" | jq '
        # Step 1: Find all workspace nodes recursively
        [.. | objects | select(.type? == "workspace")] |

        # Step 2: For each workspace, extract the name, focus state, and window count
        map({
            "name": .name,
            "focused": .focused,
            "windows": (.nodes | length + .floating_nodes | length)
        }) |

        # Step 3: Map this data to the final "active", "occupied", "empty" status
        map({
            "name": .name,
            "status": if .focused then "active"
                      elif .windows > 0 then "occupied"
                      else "empty" end
        }) |

        # Step 4: Sort the workspaces numerically for a consistent order
        sort_by(.name | tonumber)
    ' | jq -c . # Output the final array as a compact, single line
}

# Initial output
get_workspaces

# This new subscription listens for both workspace AND window events.
# This is crucial for updating the "occupied/empty" status correctly
# when you open or close a window.
swaymsg -t subscribe -m '["workspace", "window"]' -- | while read -r event; do
    get_workspaces
done
