#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SCRIPT_DIR/Fonts/consolas/"
find . | grep -i ".*\.ttf" | xargs -I {} sudo cp {} /Library/Fonts

file=/usr/local/bin/brew
if [ ! -e "$file" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install Mac Applications
brew cask install sublime-text
brew cask install google-chrome
brew cask install alfred


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
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Create ssh key
file=~/.ssh/id_rsa
if [ ! -e "$file" ]; then
    ssh-keygen -t rsa -b 4096 -C "verderese@gmail.com"
fi

mkdir -p /usr/local/bin/
sudo chown ${USER}:admin /usr/local/bin

# Create symbolic links for oh-my-zsh
cd ~/

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

xcode-select --install

# Install github
brew install gh

# Install tac
# https://unix.stackexchange.com/a/114042/162182
brew install coreutils

# Install node
brew install nvm
mkdir -p ~/.nvm
NVM_DIR="$HOME/.nvm" . /usr/local/opt/nvm/nvm.sh && nvm install 14.15.0
NVM_DIR="$HOME/.nvm" . /usr/local/opt/nvm/nvm.sh && nvm use 14.15.0
NVM_DIR="$HOME/.nvm" . /usr/local/opt/nvm/nvm.sh && nvm alias default 14.15.0

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
brew install ffmpeg
brew install glow
brew install pgcli

# Upgrade brews
brew upgrade

# Install python
echo "Installing Python Dependencies"
brew install pyenv
brew install zlib
brew install sqlite
brew install bzip2
brew install libiconv
brew install libzip
echo "Done!"
echo
echo -e "Setting Environment Variables"
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/sqlite/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/sqlite/include"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/sqlite/lib/pkgconfig"
echo "Done!"
echo
echo "Installing Python 3.8.6"
pyenv install 3.8.6
echo "Done!"
pyenv global 3.8.6
ln -s /Users/mike/.pyenv/shims/python3 /usr/local/bin/python3
pip install --upgrade pip

# # Install pipenv
pip install pipenv
rm -rf ~/.oh-my-zsh/custom/pipenv_completion.zsh
pipenv --completion >> ~/.oh-my-zsh/custom/pipenv_completion.zsh

# # Install other global pip packages
pip install pre-commit
ln -s $(which pre-commit) /usr/local/bin/pre-commit
pip install black
ln -s $(which black) /usr/local/bin/black
pip install flake8
ln -s $(which flake8) /usr/local/bin/flake8
pip install youtube-dl
ln -s $(which youtube-dl) /usr/local/bin/youtube-dl

brew cask install docker       # Install Docker
open /Applications/Docker.app  # Start Docker

terminal-notifier -message "Done setting up dev machine"
