#!/usr/bin/env sh

# Retrieve the workspace processes from tmux setting (default to 'tmux')
processes=$(tmux show-option -gqv '@workspace_usage_processes')
if [ -z "$processes" ]; then
    processes="tmux"
fi

show_mem=$(tmux show-option -gqv '@workspace_usage_mem')
if [ -z "$show_mem" ]; then
    show_mem="on"
fi

show_cpu=$(tmux show-option -gqv '@workspace_usage_cpu')
if [ -z "$show_cpu" ]; then
    show_cpu="on"
fi

refresh_interval=$(tmux show-option -gqv '@workspace_usage_refresh_interval')
if [ -z "$refresh_interval" ]; then
    refresh_interval=1
fi

# Temporary file to store last update time
last_update_file="/tmp/tmux-workspace-usage-last-update"

# Get the current time and the last update time
current_time=$(date +%s)
if [ -f "$last_update_file" ]; then
    last_update=$(cat "$last_update_file")
else
    last_update=0
fi

# Check if the refresh interval has passed
if [ $((current_time - last_update)) -lt $refresh_interval ]; then
    # If the interval hasn't passed, use cached output and exit
    cached_output=$(cat /tmp/tmux-workspace-usage-output)
    echo "$cached_output"
    exit 0
fi

# Get the list of processes and filter for relevant ones
process_list=$(ps aux | grep -E "$processes" | grep -v grep)

memory_usage=""
cpu_usage=""

if [ "$show_mem" = "on" ]; then
    memory_usage=$(echo "$process_list" | awk '{print $2, $6}' | sort -u -k1,1 | awk '{sum += $2} END {printf "%.2f MB", sum / 1024}')
fi

if [ "$show_cpu" = "on" ]; then
    cpu_usage=$(echo "$process_list" | awk '{sum += $3} END {printf "%.2f%%", sum}')
fi

output="N/A"

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

echo "$(date '+%Y-%m-%d %H:%M:%S') - Script executed" >> /tmp/tmux-workspace-usage-log.txt
echo "Processes: $process_list" >> /tmp/tmux-workspace-usage-log.txt
echo "Memory usage: $memory_usage" >> /tmp/tmux-workspace-usage-log.txt
echo "CPU usage: $cpu_usage" >> /tmp/tmux-workspace-usage-log.txt

echo "$output"
