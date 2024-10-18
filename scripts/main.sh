#!/bin/sh

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

output=""

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

echo "$output"
