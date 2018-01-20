# README #

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

1. Python 3.5
2. NodeJS
3. Tree
4. Tig

2. AWS CLI
3. Symbolic link to a bunch of useful Sublime Packages. This allows syncing between multiple comptuers
    - See the installed packages list in the Sublime UI
4. Symbolic link to a zsh theme that shows current directory, git status, and virtualenv
5. Symolic link to a `.zshrc` file with useful macros and plugins:
    1.  Plugins for git, sublime, osx, docker, virtualenv, tig, ssh-agent
    2. `termnot`
        - Usage: `termnot "This is a message"`
        - Usually used after a long script `./script.sh && termnot "I'm done!"`
    3 `docker-destroy-all` Delete all docker containers and images on the machine
    4. `rm` - Aliases `rm` to use installed trash module instead. Files deleted with `rm` are sent to
    the trash for easy recovery. If you need the system `rm` command run `/bin/rm <filename>`
    5. `setup-virtualenv <python_version (default 2.7)>` - Setup a virtualenv at `./.virtualenv/` in
    the current directory
    6. `teardown-virtualenv` - removes virtualenv in current directory
    7. `activate-virtualenv` - activates the virtualenv in current directory
    8. `get-secret <env> <filename>` gets a secret from renew secrets bucket (requires setup
        of `awscli` with a user that has access to this bucket)
    9. `gpasf <branch_name (default reviewed)>` - Run this command the directory above a bunch of
    repositries and it will checkout the given branch, pull, and update submodules
    10. `ghpr <branch_name (default reviewed)>` - Create a github pull request against the
    specified branch. Will open configured text editor to enter pull request message
    11. `fancytree` - Alias for `tree` with useful flags for permissions, colors, etc.

6. Installation and alias of `hub`, [github's additions to git](https://github.com/github/hub)
7. `ec2ssh <env>` - Script that allows easy ssh access to Renew's EC2 instances. Requires proper
    ssh keys