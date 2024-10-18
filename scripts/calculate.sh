#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"

main () {
  local processes=$(get_tmux_option '@workspace_usage_processes' 'tmux')
  local show_mem=$(get_tmux_option '@workspace_usage_mem' 'on')
  local show_cpu=$(get_tmux_option '@workspace_usage_cpu' 'on')

  # Get the status-interval from tmux settings and use it as the default for refresh_interval
  local status_interval=$(get_tmux_option '@status-interval' 15)
  local refresh_interval=$(get_tmux_option '@workspace_usage_refresh_interval' "$status_interval")
  
  # Sleep for (refresh_interval - status_interval)
  local sleep_time=$((refresh_interval - status_interval))
  if (( sleep_time > 0 )); then
    sleep "$sleep_time"
  fi

  local output="N/A"

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

  # Output the result and debug logging
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Script executed - $output" >> /tmp/tmux-workspace-usage-log.txt
  echo "$output"
}

main
