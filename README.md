# tmux-workspace-usage

A tmux plugin that shows the memory and CPU usage of your workspace processes in the tmux status bar.

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

- `@workspace_usage_processes`: A string of process names separated by | that you want to monitor.
- `@workspace_usage_mem`: Toggles memory usage display (on or off).
- `@workspace_usage_cpu`: Toggles CPU usage display (on or off).

The default configuration:
```bash
# Set the processes to monitor (customize this as needed)
set -g @workspace_usage_processes 'tmux|nvim|mason'

# Enable memory and CPU usage display (default is 'on')
set -g @workspace_usage_mem 'on'
set -g @workspace_usage_cpu 'on'

# Add the plugin output to status-right
set -g status-right '#{workspace_usage}'
```
