#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/helpers.sh"

main () {
  local processes=$(get_tmux_option '@workspace_usage_processes' 'tmux')
  local show_mem=$(get_tmux_option '@workspace_usage_mem' 'on')
  local show_cpu=$(get_tmux_option '@workspace_usage_cpu' 'on')
  local status_interval=$(get_tmux_option '@status-interval' 15)
  local interval_delay=$(get_tmux_option '@workspace_usage_interval_delay' 0)

  local mem_icon=$(get_tmux_option '@workspace_mem_icon'  )
  local cpu_icon=$(get_tmux_option '@workspace_cpu_icon'  )

  if (( interval_delay > 0 && interval_delay <= status_interval )); then
    sleep "$interval_delay"
  fi

  local output="N/A"

  # Get the list of processes and filter for relevant ones
  local process_list=$(ps aux | grep -E "$processes" | grep -v grep)

  local memory_usage=""
  local cpu_usage=""

  if [ "$show_mem" = "on" ]; then
    memory_usage=$(echo "$process_list" | awk '{print $2, $6}' | sort -u -k1,1 | awk '{sum += $2} END {printf "%3.0fMB", sum / 1024}')
  fi

  if [ "$show_cpu" = "on" ]; then
    # left pad the percentage to width two before decimal point
    cpu_usage=$(echo "$process_list" | awk '{sum += $3} END {printf "%4.1f%%", sum}')
  fi

  if [ "$show_mem" = "on" ]; then
    output="$mem_icon $memory_usage"
  fi

  if [ "$show_cpu" = "on" ]; then
    if [ -n "$output" ]; then
      output="$output | $cpu_icon $cpu_usage"
    else
      output="$cpu_icon $cpu_usage"
    fi
  fi

  echo "$output"
}

main
