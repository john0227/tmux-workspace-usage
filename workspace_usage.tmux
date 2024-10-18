#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set-option -g @workspace_usage "#($CURRENT_DIR/scripts/main.sh)"
