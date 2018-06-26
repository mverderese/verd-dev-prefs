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

zstyle :omz:plugins:ssh-agent identities id_rsa id_rsa_aws

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sublime osx docker virtualenv tig ssh-agent)

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

docker-rebuild-image() {

    if [[ -z "$1" ]]; then
        echo 'Must provide name of service (no number. use underscores). For example: "renew_api"'
        return 1
    fi

    docker_container=$1

    dev stop local-dev
    docker rm "${docker_container}_1"

    docker_image="${docker_container//_/-}"

    docker rmi "${docker_image}"
    docker images | grep "${docker_image}" | awk '{print $3}' | xargs docker rmi

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
    URL=$(git pull-request -b "${1:-reviewed}") &&
    sleep 1 &&
    open $URL
}

# Alias for deleting remote branches: Usage `drm feature/test-feature`
alias gbdr='git push origin --delete "$1"'

alias gcr='git checkout reviewed'
alias gbav='git branch --all -vv'
alias gbv='git branch -vv'
alias gdc='git diff --cached'
alias tia='tig --all'
alias gl='git pull --rebase'

gpasf () {
    for d in *; do
      if [ -d "$d/.git/" ]; then         # or:  if test -d "$d"; then
        ( cd "$d" && git checkout "${1:-reviewed}" && git pull && git submodule update )
      fi
    done
}

gloge () {
    current_branch="$(git branch | sed -n 's/^\* //p')"
    echo "Current branch: ${current_branch}"
    ticket_code=$(echo "${current_branch}" | sed 's/\(REN-[0-9]*\).*/\1/')
    echo "Ticket code: ${ticket_code}\n"
    output=$(git log ${1:-reviewed}..${current_branch} --pretty=format:'%s' | sed "s/${ticket_code} /- /g")
    echo "${output}" | /usr/local/opt/coreutils/libexec/gnubin/tac
    echo "${output}" | /usr/local/opt/coreutils/libexec/gnubin/tac | pbcopy
    echo "\nLog copied to clipboard!"
}

alias c='clear'

# https://unix.stackexchange.com/a/148548/162182
alias sudo='sudo '

alias fancytree='tree -lahgupC'

# Instead of deleting files with rm, send them to the trash.
# Depends on #https://github.com/sindresorhus/trash-cli
alias rm=trash

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
