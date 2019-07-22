#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SCRIPT_DIR/Fonts/consolas/"
find . | grep -i ".*\.ttf" | xargs -I {} sudo cp {} /Library/Fonts

file=/usr/local/bin/brew
if [ ! -e "$file" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Create symbolic links for sublime packages
cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
rm -rf ./User
ln -s "$SCRIPT_DIR/Sublime/Packages/User" ./User
rm -rf ./Themes
ln -s "$SCRIPT_DIR/Sublime/Packages/Themes" ./Themes

ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
git config --global core.editor "subl -n -w"

# Install oh-my-zsh
file=~/.oh-my-zsh/oh-my-zsh.sh
if [ ! -e "$file" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "\n\n\nRun this script again!"
    exit
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
brew install zsh-syntax-highlighting

# Create ssh key
file=~/.ssh/id_rsa
if [ ! -e "$file" ]; then
    ssh-keygen -t rsa -b 4096
fi

mkdir -p /usr/local/bin/
sudo chown ${USER}:admin /usr/local/bin

mkdir -p ~/.bin/
cp "$SCRIPT_DIR/ssh/ec2ssh.sh" ~/.bin/ec2ssh.sh
chmod u+x ~/.bin/ec2ssh.sh

# Create symbolic links for oh-my-zsh
cd ~/

rm -f ./.local_config.sh
ln -s "$SCRIPT_DIR/iTerm/.local_config.sh" ./.local_config.sh

rm -f ./.zshrc
ln -s "$SCRIPT_DIR/iTerm/.zshrc" ./.zshrc

rm -f ./.tmux.conf
ln -s "$SCRIPT_DIR/iTerm/.tmux.conf" ./.tmux.conf

rm -f ./.bash_profile
ln -s "$SCRIPT_DIR/iTerm/.bash_profile" ./.bash_profile

rm -f ./.gitconfig
ln -s "$SCRIPT_DIR/iTerm/.gitconfig" ./.gitconfig

rm -f ./.oh-my-zsh/themes/mverderese.zsh-theme
ln -s "$SCRIPT_DIR/iTerm/mverderese.zsh-theme" ./.oh-my-zsh/themes/mverderese.zsh-theme

# Create symbolic link for ssh config
rm -f ./.ssh/config
ln -s "$SCRIPT_DIR/ssh/ssh_config" ./.ssh/config

# Install hub - git alternative
brew install hub

# Install tac
# https://unix.stackexchange.com/a/114042/162182
brew install coreutils
ln -s /usr/local/bin/gtac /usr/local/bin/ta

# Install node
brew install nvm
mkdir -p ~/.nvm
NVM_DIR="$HOME/.nvm" . /usr/local/opt/nvm/nvm.sh && nvm install 8.9.3
NVM_DIR="$HOME/.nvm" . /usr/local/opt/nvm/nvm.sh && nvm use 8.9.3

# Install cachegrind
brew install qcachegrind
brew install graphviz

# Install nnn
brew install nnn

# Install speedtest_cli
brew install speedtest_cli

# Upgrade npm
npm install --global npm

# Install alfred mirror switch
mkdir ~/Development/verd-dev-prefs/alfred/Alfred.alfredpreferences/workflows
npm install --global alfred-mirror-displays

# Install npm-ls-scripts
npm install --global npm-ls-scripts

# Install trash-cli
npm install --global trash-cli

# Install terminal notifier
brew install terminal-notifier

# Install useful tools
brew install tree
brew install tmux
brew install tig
brew install postgresql
brew install yarn
brew install htop

# Upgrade brews
brew upgrade

# Install python
xcode-select --install
brew install pyenv
brew install pipenv
rm -rf ~/.oh-my-zsh/custom/pipenv_completion.zsh
pipenv --completion >> ~/.oh-my-zsh/custom/pipenv_completion.zsh

# https://github.com/pyenv/pyenv/wiki/Common-build-problems
brew install readline xz
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /

pyenv install 2.7.16 --skip-existing
# rm -rf /usr/local/bin/python2
# ln -s "$(PYENV_VERSION=2.7.16 pyenv which python2)" /usr/local/bin/python2

pyenv install 3.7.4 --skip-existing
# pyenv global 3.7.4
# rm -rf /usr/local/bin/python3
# ln -s "$(PYENV_VERSION=3.7.4 pyenv which python3)" /usr/local/bin/python3

/usr/local/bin/python3 -m pip install black

# Install python3 packages
#$(PYENV_VERSION=3.7.1 pyenv which python) -m pip install --upgrade pip
#$(PYENV_VERSION=3.7.1 pyenv which python) -m pip install virtualenv
#$(PYENV_VERSION=3.7.1 pyenv which python) -m pip install flake8
#$(PYENV_VERSION=3.7.1 pyenv which python) -m pip install awscli
#$(PYENV_VERSION=3.7.1 pyenv which python) -m pip install yamllint

# Go development
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"
brew install go
go get golang.org/x/tools/cmd/godoc
go get golang.org/x/lint/golint

brew install dep

terminal-notifier -message "Done setting up dev machine"
