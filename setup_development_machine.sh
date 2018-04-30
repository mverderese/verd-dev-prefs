# !/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

file=/usr/local/bin/brew
if [ ! -e "$file" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Create symbolic links for sublime packages
cd ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
rm -rf ./User
ln -s "$SCRIPT_DIR/Sublime/Packages/User" ./User

ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
git config --global core.editor "subl -n -w"

# Install oh-my-zsh
file=~/.oh-my-zsh/oh-my-zsh.sh
if [ ! -e "$file" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "\n\n\nRun this script again!"
    exit
fi

# Create ssh key
file=~/.ssh/id_rsa
if [ ! -e "$file" ]; then
    ssh-keygen -t rsa -b 4096
fi

mkdir -p ~/.bin/
cp "$SCRIPT_DIR/ssh/ec2ssh.sh" ~/.bin/ec2ssh.sh
chmod u+x ~/.bin/ec2ssh.sh

# Create symbolic links for oh-my-zsh
cd ~/
rm -f ./.zshrc
ln -s "$SCRIPT_DIR/iTerm/.zshrc" ./.zshrc

rm -f ./.bash_profile
ln -s "$SCRIPT_DIR/iTerm/.bash_profile" ./.bash_profile

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

# Install speedtest_cli
brew install speedtest_cli

# Upgrade npm
npm install --global npm

# Install npm-ls-scripts
npm install --global npm-ls-scripts

# Install trash-cli
npm install --global trash-cli

# Install terminal notifier
brew install terminal-notifier

# Install useful tools
brew install tree
brew install tig
brew install postgresql
brew install yarn

brew uninstall python3
brew uninstall python2

# Upgrade brews
brew upgrade

# Install python3
xcode-select --install
brew install pyenv
pyenv install 2.7.14 --skip-existing
ln -s "$(PYENV_VERSION=2.7.14 pyenv which python2)" /usr/local/bin/python2
pyenv install 3.5.5 --skip-existing
pyenv global 3.5.5

terminal-notifier -message "Root password needed"

# Install python3 packages
sudo -H $(PYENV_VERSION=3.5.5 pyenv which python) -m pip install --upgrade pip
sudo -H $(PYENV_VERSION=3.5.5 pyenv which python) -m pip install virtualenv
sudo -H $(PYENV_VERSION=3.5.5 pyenv which python) -m pip install flake8
sudo -H $(PYENV_VERSION=3.5.5 pyenv which python) -m pip install awscli
sudo -H $(PYENV_VERSION=3.5.5 pyenv which python) -m pip install yamllint

terminal-notifier -message "Done setting up dev machine"
