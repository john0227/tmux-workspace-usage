#!/bin/sh

# Retrieve the workspace processes from tmux setting (default to 'tmux|nvim|mason')
processes=$(tmux show-option -gqv '@workspace_usage_processes')
if [ -z "$processes" ]; then
    processes="tmux"
fi

# Get the list of processes and filter for relevant ones
process_list=$(ps aux | grep -E "$processes" | grep -v grep)

# Calculate unique memory usage by PID (RSS column, field 6)
memory_usage=$(echo "$process_list" | awk '{print $2, $6}' | sort -u -k1,1 | awk '{sum += $2} END {printf "%.2f MB\n", sum / 1024}')

# Output the calculated memory usage
echo "$memory_usage"
