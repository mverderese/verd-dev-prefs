#!/bin/bash

# Read input JSON
input=$(cat)

# Extract basic info
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
display_path="${cwd/#$HOME/~}"
model=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')

# Build model line with context and output style
context_info=''
usage=$(echo "$input" | jq '.context_window.current_usage')
if [ "$usage" != "null" ]; then
    current=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    size=$(echo "$input" | jq '.context_window.context_window_size')
    if [ "$current" -gt 0 ] && [ "$size" -gt 0 ]; then
        pct=$((current * 100 / size))
        context_info=$(printf ' | %d%% context' "$pct")
    fi
fi

# Add output style if not default
style_info=''
if [ "$output_style" != "null" ] && [ "$output_style" != "default" ]; then
    style_info=$(printf ' | %s' "$output_style")
fi

# Add vim mode if present
vim_info=''
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
if [ -n "$vim_mode" ]; then
    vim_info=$(printf ' | vim:%s' "$vim_mode")
fi

# Get git info
git_branch=$(cd "$cwd" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null)
git_info=''
if [ -n "$git_branch" ]; then
    git_status=$(cd "$cwd" && git status --porcelain 2>/dev/null)
    if [ -n "$git_status" ]; then
        git_info=$(printf '\n\033[1;34mgit:(\033[0;31m%s\033[1;34m) \033[0;31m✗\033[0m' "$git_branch")
    else
        git_info=$(printf '\n\033[1;34mgit:(\033[0;31m%s\033[1;34m)\033[0m' "$git_branch")
    fi
fi

# Output: Model and context on first line, path and git on second line.
# Model line and path use the terminal's default foreground so they stay
# legible on both light and dark backgrounds (matches the zsh prompt theme).
printf '%s%s%s%s\n%s%s' "$model" "$context_info" "$style_info" "$vim_info" "$display_path" "$git_info"
