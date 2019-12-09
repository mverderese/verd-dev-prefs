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

xcode-select --install

# Install hub - git alternative
brew install hub

# Install tac
# https://unix.stackexchange.com/a/114042/162182
brew install coreutils

# Install node
brew install nvm
mkdir -p ~/.nvm
NVM_DIR="$HOME/.nvm" . /usr/local/opt/nvm/nvm.sh && nvm install 12.13.1
NVM_DIR="$HOME/.nvm" . /usr/local/opt/nvm/nvm.sh && nvm use 12.13.1
NVM_DIR="$HOME/.nvm" . /usr/local/opt/nvm/nvm.sh && nvm alias default 12.13.1

# Install speedtest_cli
brew install speedtest_cli

# Install terminal notifier
brew install terminal-notifier

# Install useful tools
brew install tree
brew install tmux
brew install tig
brew install postgresql
brew install htop

# Upgrade brews
brew upgrade

# Install python
xcode-select --install
brew install pyenv
pyenv install 3.8.0 --skip-existing
pyenv global 3.8.0
ln -s /Users/mike/.pyenv/shims/python3 /usr/local/bin/python3
pip install --upgrade pip

# # Install pipenv
pip install pipenv
rm -rf ~/.oh-my-zsh/custom/pipenv_completion.zsh
pipenv --completion >> ~/.oh-my-zsh/custom/pipenv_completion.zsh

# # Install other global pip packages
pip install awscli
pip install pre-commit

terminal-notifier -message "Done setting up dev machine"
