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
    kubectl
    sublime
    docker
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Source external files
source $HOME/.bash_profile

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
     # Delete cache
     docker rm $(docker ps --filter=status=exited --filter=status=created -q)
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

alias gbdr='git push origin --delete'
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

gcla () { gcloud config configurations activate $1 }
gcll () { gcloud config configurations list }

odin-dev-db () {
    gcla odin-main
    gcloud config set account mike@useodin.com
    cloud-sql-proxy --address 0.0.0.0 --port 5433 --gcloud-auth odin-main:us-central1:odin-main-dev-anon-instance-us-central1-pg-db
}
odin-qa-db () {
    gcla odin-main
    gcloud config set account mike@useodin.com
    cloud-sql-proxy --address 0.0.0.0 --port 5434 --gcloud-auth odin-main:us-central1:odin-main-qa-anon-instance-us-central1-pg-db
}
odin-stg-db () {
    gcla odin-prod
    gcloud config set account mike@useodin.com
    cloud-sql-proxy --address 0.0.0.0 --port 5435 --gcloud-auth odin-prod:us-central1:odin-prod-stg-instance-us-central1-pg-db
}
odin-prod-replica-db () {
    gcla odin-prod
    gcloud config set account mike@useodin.com
    cloud-sql-proxy --address 0.0.0.0 --port 5436 --gcloud-auth odin-prod:us-central1:odin-prod-prod02-us-central1-pg-db-replica-2
}
odin-prod-db () {
    gcla odin-prod
    gcloud config set account mike@useodin.com
    cloud-sql-proxy --address 0.0.0.0 --port 5437 --gcloud-auth odin-prod:us-central1:odin-prod-prod02-us-central1-pg-db
}
wellcore-prod-replica-db () {
    gcla wellcore-prod
    gcloud config set account mike@redkrypton.com
    cloud-sql-proxy --address 0.0.0.0 --port 5440 --gcloud-auth wellcore-cloud-prod:us-central1:wellcore-db-prod-replica
}   
wellcore-prod-db () {
    gcla wellcore-prod
    gcloud config set account mike@redkrypton.com
    cloud-sql-proxy --address 0.0.0.0 --port 5441 --gcloud-auth wellcore-cloud-prod:us-central1:wellcore-db-prod
}  
wellcore-non-prod-db () {
    gcla wellcore-non-prod
    gcloud config set account mike@redkrypton.com
    cloud-sql-proxy --address 0.0.0.0 --port 5442 --gcloud-auth wellcore-cloud-non-prod:us-central1:wellcore-db-non-prod
}   
gleamery-non-prod-db () {
    gcla gleamery-non-prod
    gcloud config set account mike@redkrypton.com
    cloud-sql-proxy --address 0.0.0.0 --port 5450 --gcloud-auth gleamery-non-prod:us-central1:gleamery-db-non-prod
} 
gleamery-prod-db () {
    gcla gleamery-prod
    gcloud config set account mike@redkrypton.com
    cloud-sql-proxy --address 0.0.0.0 --port 5451 --gcloud-auth gleamery-prod:us-central1:gleamery-db-prod
}   


alias c='clear'

# https://unix.stackexchange.com/a/148548/162182
alias sudo='sudo '

alias fancytree='tree -lhgupC'

tcp-process() {
    lsof -i tcp:$1 | grep LISTEN
}

alias pag='ps aux | grep -i $1'

alias randpass='openssl rand -base64 30'

eval "$(nodenv init -)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
