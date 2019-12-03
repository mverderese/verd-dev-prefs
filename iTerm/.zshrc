#@IgnoreInspection BashAddShebang
# If you come from bash you might have to change your $PATH.
# Recommended by Homebrew

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

export HISTTIMEFORMAT="%d/%m/%y %T "

# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh
export VIRTUAL_ENV_DISABLE_PROMPT=

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="mverderese"

autoload bashcompinit
bashcompinit

# https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    gitfast
    sublime
    osx
    docker
    ssh-agent
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# AWS Assume Role
source $(which assume-role)

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export EDITOR="/usr/local/bin/subl"

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

# # https://github.com/renewdotcom/renew-dev-tools/pull/1/
# export AWS_PROFILE=mfa_session

# https://github.com/github/hub/issues/1219
ghpr() {
    current_branch="$(git branch | sed -n 's/^\* //p')"
    git push -u origin ${current_branch} &&
    URL=$(hub pull-request -b "${1:-master}") &&
    sleep 1 &&
    open $URL
}

unset_vars_search() {
  while read var; do unset $var; done < <(env | grep -i $1 | sed 's/=.*//g')
}

unset_aws() {
  unset_vars_search aws
}

source_dotenv() {
  export $(grep -v '^#' .env | xargs -0)
}

# Alias for deleting remote branches: Usage `drm feature/test-feature`
alias gbdr='git push origin --delete "$1"'

alias gbav='git branch --all -vv'
alias gbv='git branch -vv'
alias gdc='git diff --cached'
alias tia='tig --all'
alias gl='git pull --rebase'
alias gcd='git checkout development'
alias gdst='git diff --stat'
alias gdsst='git diff --shortstat'

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

gloge () {
    current_branch="$(git branch | sed -n 's/^\* //p')"
    echo "Current branch: ${current_branch}"
    ticket_code=$(echo "${current_branch}" | sed 's/\(REN-[0-9]*\).*/\1/')
    echo "Ticket code: ${ticket_code}\n"
    output=$(git log ${1:-master}..${current_branch} --pretty=format:'%s' | sed "s/${ticket_code} /- /g")
    echo "${output}" | /usr/local/opt/coreutils/libexec/gnubin/tac
    echo "${output}" | /usr/local/opt/coreutils/libexec/gnubin/tac | pbcopy
    echo "\nLog copied to clipboard!"
}

alias c='clear'

# https://unix.stackexchange.com/a/148548/162182
alias sudo='sudo '

alias fancytree='tree -lhgupC'

alias verd-dev="cd ~/Development/verd-dev-prefs"

# https://www.michaelehead.com/2016/02/06/installing-gems-without-sudo.html
# Fix ruby sudo install
export GEM_HOME=${HOME}/.gem
export PATH="$GEM_HOME/bin:$PATH"

alias ec2ssh='~/.bin/ec2ssh.sh'

tcp-process() {
    sudo lsof -i tcp:$1 | grep LISTEN
}

alias pag='ps aux | grep -i $1'

# Go stuff
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"