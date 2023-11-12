# Verd Development Tools and Preferences #

A bunch of useful tools and preferences for development on NodeJS and Python on a Mac with
SublimeText

## Prerequisites
1. Install SublimeText 3
2. Install SublimeText PackageControl
3. Run SublimeText one time

## Installation
    bash ./setup_development_machine.sh

You'll be prompted for your root password a few times

## What is installed

1. Python
2. NodeJS
3. Shell tools
4. Symbolic link to a zsh theme that shows current directory, git status, and virtualenv
5. Symolic link to a `.zshrc` file with useful macros and plugins
6. Github
7. Google Cloud SDK

Once complete, run the following:
```
gh auth login
```

```
gcloud auth login
```