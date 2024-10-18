#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"

main () {
  local processes=$(get_tmux_option '@workspace_usage_processes' 'tmux')
  local show_mem=$(get_tmux_option '@workspace_usage_mem' 'on')
  local show_cpu=$(get_tmux_option '@workspace_usage_cpu' 'on')
  local refresh_interval=$(get_tmux_option '@workspace_usage_refresh_interval' 1)

  local output="N/A"

  # Temporary file to store last update time
  local last_update_file="/tmp/tmux-workspace-usage-last-update"

  # Get the current time in seconds since the epoch
  local current_time=$(date +%s)

  if [ ! -f "$last_update_file" ]; then
      local last_update=0
  else
      local last_update=$(cat "$last_update_file")
      # If last_update is empty or not numeric, set it to 0
      if [[ -z "$last_update" || ! "$last_update" =~ ^[0-9]+$ ]]; then
          last_update=0
      fi
  fi

  # Check if the refresh interval has passed
  if ((current_time - last_update < refresh_interval)); then
      # Check if the cached output file exists before reading it
      if [ -f /tmp/tmux-workspace-usage-output ]; then
          local cached_output=$(cat /tmp/tmux-workspace-usage-output)
          echo "$cached_output"
      else
          echo "$output"
      fi
      exit 0
  fi

  # Get the list of processes and filter for relevant ones
  local process_list=$(ps aux | grep -E "$processes" | grep -v grep)

  local memory_usage=""
  local cpu_usage=""

  if [ "$show_mem" = "on" ]; then
    memory_usage=$(echo "$process_list" | awk '{print $2, $6}' | sort -u -k1,1 | awk '{sum += $2} END {printf "%.2f MB", sum / 1024}')
  fi

  if [ "$show_cpu" = "on" ]; then
    cpu_usage=$(echo "$process_list" | awk '{sum += $3} END {printf "%.2f%%", sum}')
  fi

  if [ "$show_mem" = "on" ]; then
    output="$memory_usage"
  fi

  if [ "$show_cpu" = "on" ]; then
    if [ -n "$output" ]; then
      output="$output | $cpu_usage"
    else
      output="$cpu_usage"
    fi
  fi

  # Save current time as the last update time
  echo "$current_time" > "$last_update_file"
  echo "$output" > /tmp/tmux-workspace-usage-output

  # Debug logging
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Script executed - $output" >> /tmp/tmux-workspace-usage-log.txt
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $processes $show_mem $show_cpu $refresh_interval" >> /tmp/tmux-workspace-usage-log.txt

  echo "$output"
}

main
