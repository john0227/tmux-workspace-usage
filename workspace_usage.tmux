#!/bin/sh

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/scripts/helpers.sh"

replace_placeholder_in_status_line() {
  placeholder="\#{$1}"
  script="#($2)"
  status_line_side=$3
  old_status_line=$(get_tmux_option $status_line_side)
  new_status_line=${old_status_line/$placeholder/$script}

  set_tmux_option $status_line_side "$new_status_line"
}

main () {
  workspace_usage="$CURRENT_DIR/scripts/calculate.sh"
  replace_placeholder_in_status_line "workspace_usage" "$workspace_usage" "status-right"
  replace_placeholder_in_status_line "workspace_usage" "$workspace_usage" "status-left"
}

main
