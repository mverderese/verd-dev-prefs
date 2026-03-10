# Verd Development Tools and Preferences

A modern Mac dev machine setup for Node.js and Python development.

## Installation
```
bash ./setup_development_machine.sh
```

You'll be prompted for your root password a few times.

## What is installed

1. Python (via brew)
2. Node.js (via fnm — Fast Node Manager)
3. Shell tools (tree, tmux, tig, ffmpeg, pgcli, gws)
4. Claude Code (`@anthropic-ai/claude-code`)
5. Google Cloud SDK
6. Docker
7. GitHub CLI (`gh`)
8. Symbolic link to a zsh theme that shows current directory, git status, and virtualenv
9. Symbolic link to a `.zshrc` file with useful aliases and plugins

## Folder Structure

```
verd-dev-prefs/
├── dotfiles/                    ← shell config files
│   ├── dotzshrc                 ← symlinked to ~/.zshrc
│   ├── dotgitconfig             ← symlinked to ~/.gitconfig
│   └── mverderese.zsh-theme     ← symlinked to ~/.oh-my-zsh/themes/
├── iTerm/                       ← iTerm2 app config
│   └── com.googlecode.iterm2.plist
├── Fonts/
├── Alfred/
└── setup_development_machine.sh
```
