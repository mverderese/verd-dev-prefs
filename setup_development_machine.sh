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
    echo "Run this script again!"
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

# Install node
brew install node@8

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

# Install python3
brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/ec545d45d4512ace3570782283df4ecda6bb0044/Formula/python3.rb
brew pin python3

# Install useful tools
brew install tree
brew install tig
brew install postgresql

# Upgrade brews
brew upgrade

terminal-notifier -message "Root password needed"

# Install python3 packages
sudo -H python3 -m pip install --upgrade pip
sudo -H python3 -m pip install virtualenv
sudo -H python3 -m pip install flake8
sudo -H python3 -m pip install awscli

terminal-notifier -message "Done setting up dev machine"
