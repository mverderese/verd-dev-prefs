# CLAUDE.md — verd-dev-prefs

## Project Purpose

Personal dotfiles and dev machine setup for macOS. Running `setup.sh` bootstraps a fresh Mac with all tools and symlinks config files into place.

## Folder Layout

- `dotfiles/` — shell config files (zshrc, colors.zsh light/dark terminal palette, gitconfig, global gitignore, zsh theme) and global Claude Code instructions. `claude-global.md` is deliberately not named `CLAUDE.md` so Claude Code doesn't load it as project instructions for this folder. Files use `dot` prefix instead of `.` to avoid hidden-file confusion in editors.
- `iTerm/` — iTerm2 app-level config only (`com.googlecode.iterm2.plist`).
- `Fonts/` — JetBrains Mono font files.
- `Alfred/` — Alfred preferences.
- `setup.sh` — main bootstrap script.

## How Symlinks Work

The setup script creates symlinks from the repo into `~`:

| Repo file | Symlinked to |
|---|---|
| `dotfiles/dotzshrc` | `~/.zshrc` |
| `dotfiles/dotgitconfig` | `~/.gitconfig` |
| `dotfiles/mverderese.zsh-theme` | `~/.oh-my-zsh/themes/mverderese.zsh-theme` |
| `dotfiles/dotgitignore_global` | `~/.config/git/ignore` (git's default global excludes file) |
| `dotfiles/claude-global.md` | `~/.claude/CLAUDE.md` (user-level Claude Code instructions) |
| `dotfiles/statusline-command.sh` | `~/.claude/statusline-command.sh` (Claude Code status line script) |

Edit the files in this repo — changes take effect immediately since the shell reads through the symlink.

## Adding New Tools

Add `brew install <tool>` to `setup.sh`. For Node-based global tools, install after the `fnm install --lts` block so Node is available.

## Local Overrides

For machine-specific config that shouldn't be committed, create `~/.zshrc.local` and source it at the end of `dotzshrc` (not yet wired up — add if needed).
