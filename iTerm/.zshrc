# If you come from bash you might have to change your $PATH.
# Recommended by Homebrew

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# Path to your oh-my-zsh installation.
export ZSH=/Users/mike/.oh-my-zsh
export VIRTUAL_ENV_DISABLE_PROMPT=

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="mverderese"

# https://www.reddit.com/r/zsh/comments/46lf65/ohmyzsh_how_can_i_see_how_much_time_the_last/d0ti1sv/
function preexec() {
    timer=${timer:-$SECONDS}
}

function precmd() {
    if [ $timer ]; then
        timer_show=$(($SECONDS - $timer))
        export RPROMPT="${timer_show}s"
        unset timer
    fi
}

# https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Get local env variables
source "$HOME/.local_config.sh"

zstyle :omz:plugins:ssh-agent identities id_rsa id_rsa_aws

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    sublime
    osx
    docker
    virtualenv
    ssh-agent
    zsh-autosuggestions
    pipenv
)

source $ZSH/oh-my-zsh.sh

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYTHON_EXEC="$(PYENV_VERSION=2.7.14 pyenv which python2)"

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
}

denter() { docker exec -it $1 /bin/bash; }
dlog() { docker logs $1 --tail 150 -f }

docker-rebuild-renew-image() {

    if [[ -z "$1" ]]; then
        echo 'Must provide name of service to search (no number. use underscores). For example: "api"'
        return 1
    fi

    dev stop local-dev

    docker ps -a | grep $1 | awk '{print $1}'| xargs docker rm -f

    dev build local-dev
    dev start local-dev
}

# https://github.com/renewdotcom/renew-dev-tools/pull/1/
export AWS_PROFILE=mfa_session

# https://github.com/github/hub#aliasing
eval "$(hub alias -s)"

# https://github.com/github/hub/issues/1219
ghpr() {
    current_branch="$(git branch | sed -n 's/^\* //p')"
    git push -u origin ${current_branch} &&
    URL=$(git pull-request -b "${1:-master}") &&
    sleep 1 &&
    open $URL
}

# Alias for deleting remote branches: Usage `drm feature/test-feature`
alias gbdr='git push origin --delete "$1"'

alias gbav='git branch --all -vv'
alias gbv='git branch -vv'
alias gdc='git diff --cached'
alias tia='tig --all'
alias gl='git pull --rebase'

gpasf () {
    for d in *; do
      if [ -d "$d/.git/" ]; then         # or:  if test -d "$d"; then
        ( cd "$d" && git clean -f && git prune && git fetch --all --prune && git checkout "${1:-master}" && git pull && git submodule update )
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

# Instead of deleting files with rm, send them to the trash.
# Depends on #https://github.com/sindresorhus/trash-cli
alias rm=trash

# https://www.michaelehead.com/2016/02/06/installing-gems-without-sudo.html
# Fix ruby sudo install
export GEM_HOME=/Users/mike/.gem
export PATH="$GEM_HOME/bin:$PATH"

alias ec2ssh='~/.bin/ec2ssh.sh'
alias get-secret='~/.bin/get-secret.sh'

setup-virtualenv() {

    # Create virtualenv
    file=./.venv/bin/activate
    if [ ! -e "$file" ]; then
        $(PYENV_VERSION=3.5.5 pyenv which python) -m virtualenv ./.venv --python="${1:-python3}"
    else
        echo "virtualenv already created"
    fi

    # Activate virtualenv
    . ./.venv/bin/activate

    # Install requirements
    file=./requirements.txt
    if [ ! -e "$file" ]; then
        echo "No requirements.txt found"
    else
        pip3 install -r "$file" --process-dependency-links
    fi
}

teardown-virtualenv() {
    file=./.venv/bin/activate
    if [ ! -e "$file" ]; then
        echo "No virtualenv found at $file"
    else
        deactivate
        rm -rf ./.venv/
    fi
}

alias activate-virtualenv='. ./.venv/bin/activate'

# https://stackoverflow.com/a/33844061/2565551
capture() {

    sudo dtrace -p "$1" -qn '
        syscall::write*:entry
        /pid == $target && arg0 == 1/ {
            printf("%s", copyinstr(arg1, arg2));
        }
    '
}

tcp-process() {
    sudo lsof -i tcp:$1 | grep LISTEN
}

run-local-dev() {
    dev run local-dev > /tmp/docker_output.log &
}

alias verd-dev='cd ~/Development/verd-dev-prefs/'
alias api='cd ~/Development/renew/renew-api/'
alias slug='cd ~/Development/renew/renew-data-slug/'
alias servers='cd ~/Development/renew/renew-servers/'

alias pag='ps aux | grep -i $1'