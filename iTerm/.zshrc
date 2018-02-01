# If you come from bash you might have to change your $PATH.
# Recommended by Homebrew
export PATH="/usr/local/opt/node@8/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=/Users/mike/.oh-my-zsh
export VIRTUAL_ENV_DISABLE_PROMPT=

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="mverderese"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sublime osx docker virtualenv tig ssh-agent)

source $ZSH/oh-my-zsh.sh

termnot() { terminal-notifier -message "$1" -execute 'open /Applications/iTerm.app'; }

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

# https://github.com/github/hub#aliasing
eval "$(hub alias -s)"

# https://github.com/github/hub/issues/1219
ghpr() {
    git push &&
    URL=$(git pull-request -b "${1:-reviewed}") &&
    sleep 1 &&
    open $URL
}

# Alias for deleting remote branches: Usage `drm feature/test-feature`
alias gbdr='git push origin --delete "$1"'

alias gcr='git checkout reviewed'
alias gbav='git branch --all -vv'
alias gbv='git branch -vv'
alias tia='tig --all'

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
    echo "${output}"
    echo "${output}" | pbcopy
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

setup-virtualenv() {

    # Create virtualenv
    file=./.venv/bin/activate
    if [ ! -e "$file" ]; then
        virtualenv ./.venv --python="${1:-python2.7}"
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

function get-secret() {
    local bucket='com.renew.s3.secrets'
    local env=$1
    local secret=$2
    echo "$(aws s3 cp s3://$bucket/$env/$secret -)" | xargs echo -n | pbcopy
}