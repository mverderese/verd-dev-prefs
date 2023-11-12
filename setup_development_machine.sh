#!/usr/bin/env zsh

xcode-select --install

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SCRIPT_DIR/Fonts/consolas/"
find . | grep -i ".*\.ttf" | xargs -I {} sudo cp {} /Library/Fonts

file=/usr/local/bin/brew
if [ ! -e "$file" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Create secrets file for shell
touch ~/.zsh_env

mkdir -p /usr/local/bin/
sudo chown ${USER}:admin /usr/local/bin

ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
git config --global core.editor "subl -n -w"

# Install oh-my-zsh
file=~/.oh-my-zsh/oh-my-zsh.sh
if [ ! -e "$file" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "\n\n\nRun this script again!"
    exit
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


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

# Install github
brew install gh

# Install tac
# https://unix.stackexchange.com/a/114042/162182
brew install coreutils

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
echo "Done!"
echo

echo "Installing Python 3.12.0"
pyenv install 3.12.0
echo "Done!"
pyenv global 3.12.0
pyenv exec pip install --upgrade pip

# Install node
brew install nodenv
nodenv install 20.9.0
nodenv global 20.9.0

brew install --cask google-cloud-sdk

brew install docker

gh auth login

gcloud auth login mike@useodin.com
gcloud auth login mike@redkrypton.com

gcloud config configurations create odin-main
gcloud config configurations activate odin-main
gcloud config set account mike@useodin.com
gcloud config set project odin-main
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

gcloud config configurations create odin-prod
gcloud config configurations activate odin-prod
gcloud config set account mike@useodin.com
gcloud config set project odin-prod
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

gcloud config configurations create wellcore-non-prod
gcloud config configurations activate wellcore-non-prod
gcloud config set account mike@redkrypton.com
gcloud config set project wellcore-cloud-non-prod
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

gcloud config configurations create wellcore-prod
gcloud config configurations activate wellcore-prod
gcloud config set account mike@redkrypton.com
gcloud config set project wellcore-cloud-prod
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

gcloud config configurations create gleamery-prod
gcloud config configurations activate gleamery-prod
gcloud config set account mike@redkrypton.com
gcloud config set project gleamery-prod
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

gcloud config configurations create gleamery-non-prod
gcloud config configurations activate gleamery-non-prod
gcloud config set account mike@redkrypton.com
gcloud config set project gleamery-non-prod
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.7.1/cloud-sql-proxy.darwin.amd64
mv ./cloud-sql-proxy /usr/local/bin/cloud-sql-proxy
chmod +x /usr/local/bin/cloud-sql-proxy

terminal-notifier -message "Done setting up dev machine"
