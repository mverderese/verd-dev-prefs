# Temporary files

- A `.local/` directory at the root of any git repo is globally gitignored (`~/.config/git/ignore`). When working in a repo, write temporary files (scratch scripts, intermediate outputs, logs, notes, downloads) to `<repo-root>/.local/` instead of `/tmp` or elsewhere in the tree. Create it if it doesn't exist.
