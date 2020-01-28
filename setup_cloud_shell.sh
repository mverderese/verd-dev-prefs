#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install oh-my-zsh
file=~/.oh-my-zsh/oh-my-zsh.sh
if [ ! -e "$file" ]; then
    sudo apt install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "\n\n\nRun this script again!"
    exit
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


mkdir -p /usr/local/bin/
sudo chown ${USER}:${USER} /usr/local/bin

# Create symbolic links for oh-my-zsh
cd ~/

rm -f ./.zshrc
ln -s "$SCRIPT_DIR/iTerm/.zshrc_gcs" ./.zshrc

rm -f ./.tmux.conf
ln -s "$SCRIPT_DIR/iTerm/.tmux.conf" ./.tmux.conf

rm -f ./.bash_profile
ln -s "$SCRIPT_DIR/iTerm/.bash_profile" ./.bash_profile

rm -f ./.gitconfig
ln -s "$SCRIPT_DIR/iTerm/.gitconfig_gcs" ./.gitconfig

rm -f ./.oh-my-zsh/themes/mverderese.zsh-theme
ln -s "$SCRIPT_DIR/iTerm/mverderese.zsh-theme" ./.oh-my-zsh/themes/mverderese.zsh-theme

# Create symbolic link for ssh config
rm -f ./.ssh/config
ln -s "$SCRIPT_DIR/ssh/ssh_config" ./.ssh/config

# Supress apt warnings
mkdir -p ~/.cloudshell/
touch ~/.cloudshell/no-apt-get-warning

# Install homebrew
# https://docs.brew.sh/Homebrew-on-Linux
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

# Install hub - git alternative
brew install hub

# Install tac
# https://unix.stackexchange.com/a/114042/162182
brew install coreutils

# Install node
sudo rm -rf /usr/local/nvm
brew install nvm
mkdir -p ~/.nvm
NVM_DIR="$HOME/.nvm" . /home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh && nvm install 12.13.1
NVM_DIR="$HOME/.nvm" . /home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh && nvm use 12.13.1
NVM_DIR="$HOME/.nvm" . /home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh && nvm alias default 12.13.1

# Install speedtest_cli
brew install speedtest_cli

# Install useful tools
brew install tree
brew install tmux
brew install tig
brew install postgresql

# Upgrade brews
brew upgrade

# Install python
brew install pyenv
pyenv install 3.8.0 --skip-existing
pyenv global 3.8.0
ln -s /Users/mike/.pyenv/shims/python3 /usr/local/bin/python3
/home/mike/.pyenv/versions/3.8.0/bin/pip3.8 install --upgrade pip

# # Install pipenv
/home/mike/.pyenv/versions/3.8.0/bin/pip3.8 install pipenv
rm -rf ~/.oh-my-zsh/custom/pipenv_completion.zsh
pipenv --completion >> ~/.oh-my-zsh/custom/pipenv_completion.zsh

# # Install other global pip packages
/home/mike/.pyenv/versions/3.8.0/bin/pip3.8 install awscli
/home/mike/.pyenv/versions/3.8.0/bin/pip3.8 install pre-commit
ln -s /home/mike/.pyenv/versions/3.8.0/bin/pre-commit /usr/local/bin/pre-commit
/home/mike/.pyenv/versions/3.8.0/bin/pip3.8 install black
ln -s /home/mike/.pyenv/versions/3.8.0/bin/black /usr/local/bin/black
/home/mike/.pyenv/versions/3.8.0/bin/pip3.8 install flake8
ln -s /home/mike/.pyenv/versions/3.8.0/bin/flake8 /usr/local/bin/flake8
