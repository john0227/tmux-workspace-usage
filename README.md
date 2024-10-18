# Workspace usage plugin for tmux
> Displays the memory and CPU usage of your workspace processes in the tmux status bar.

<img width="1512" alt="image" src="https://github.com/user-attachments/assets/c2a060e0-7124-4761-98a5-9f92eea94d0c">

## Features

- Displays memory usage in MB.
- Displays CPU usage as a percentage.
- Configurable list of processes to monitor.
- Toggle memory and CPU usage display on or off via tmux settings.

## Installation

1. Using [TPM](https://github.com/tmux-plugins/tpm), add the following line to your `~/.tmux.conf` file:

```bash
set -g @plugin 'sjdonado/tmux-workspace-usage'
```

> **Note**: The above line should be _before_ `run '~/.tmux/plugins/tpm/tpm'`

2. Then press `tmux-prefix` + <kbd>I</kbd> (capital i, as in **I**nstall) to fetch the plugin as per the TPM installation instructions

## Configuration

- `@workspace_usage_processes`: A string of process names separated by `|` that you want to monitor.
- `@workspace_usage_mem`: Toggles memory usage display (`on` or `off`).
- `@workspace_usage_cpu`: Toggles CPU usage display (`on` or `off`).
- `@workspace_usage_interval_delay`: The amount of time (in seconds) to delay updates. If set to a value greater than `@status-interval`, the delay will be skipped.

### Example:
```bash
# Set the processes to monitor, customize this as needed (default is 'tmux')
set -g @workspace_usage_processes 'tmux|nvim|mason'

# Enable memory and CPU usage display (default is 'on')
set -g @workspace_usage_mem 'on'
set -g @workspace_usage_cpu 'on'

# Set the interval delay in seconds, updates every 20 seconds if @status-interval is 15 (default is 0)
set -g @workspace_usage_interval_delay 5

# Add the plugin output to status-right
set -g status-right '#{workspace_usage}'
```

## License
[MIT](https://github.com/sjdonado/tmux-workspace-usage/blob/master/LICENSE.md)
