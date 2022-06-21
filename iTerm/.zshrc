#@IgnoreInspection BashAddShebang

###
#
# Setup Environment Variables
#
###

# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

export EDITOR="/usr/local/bin/subl"

# https://www.michaelehead.com/2016/02/06/installing-gems-without-sudo.html
# Fix ruby sudo install
export GEM_HOME=${HOME}/.gem
export PATH="$GEM_HOME/bin:$PATH"

###
#
# Oh My Zsh setup
#
###

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="mverderese"

autoload bashcompinit
bashcompinit

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    sublime
    docker
    ssh-agent
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Source external files
source $HOME/.bash_profile
source $HOME/.zprofile
source $HOME/.zsh_env

###
#
# Terminal alsiases and functions
#
###

termnot() { terminal-notifier -sound Ping -message "$1" -execute 'open /Applications/iTerm.app'; }

utime () {
    if [[ -n "$1" ]]; then
        date -r $1;
    else
        date +%s;
    fi
}

docker-stop-all() {
    docker stop $(docker ps -aq)
}

docker-destroy-all() {
     # Stop all containers
     docker stop $(docker ps -a -q)
     # Delete all containers
     docker rm $(docker ps -a -q)
     # Delete all images
     docker rmi $(docker images -q) -f
     # Delete all networks
     docker network rm $(docker network ls -q)
}

denter() { docker exec -it $1 /bin/bash; }
dlog() { docker logs $1 --tail 150 -f }

docker-compose-rebuild() {
    docker-compose down &&
    docker-compose rm -f -s &&
    docker-compose pull &&
    docker-compose build --no-cache &&
    docker-compose --compatibility up --force-recreate
}

source_dotenv() {
  export $(grep -v '^#' .env | xargs -0)
}

alias gbdr='git push origin --delete "$1"'
alias gbav='git branch --all -vv'
alias gbv='git branch -vv'
alias gdc='git diff --cached'
alias tia='tig --all'
alias gdst='git diff --stat'
alias gdsst='git diff --shortstat'
alias glom='git pull origin $(git_main_branch)'

gpasf () {
    for d in *; do
      if [ -d "$d/.git/" ]; then         # or:  if test -d "$d"; then
        ( cd "$d" && git clean -f && git prune && git fetch --all --prune && git checkout && git pull && git submodule update )
      fi
    done
}

gpasfforce () {
    for d in *; do
      if [ -d "$d/.git/" ]; then         # or:  if test -d "$d"; then
        ( cd "$d" && git clean -f && git add --all && git reset --hard && git prune && git fetch --all --prune && git checkout && git pull && git submodule update )
      fi
    done
}

alias c='clear'

# https://unix.stackexchange.com/a/148548/162182
alias sudo='sudo '

alias fancytree='tree -lhgupC'

tcp-process() {
    sudo lsof -i tcp:$1 | grep LISTEN
}

alias pag='ps aux | grep -i $1'

alias randpass='openssl rand -base64 30'

