#!/usr/bin/env zsh

xcode-select --install

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SCRIPT_DIR/Fonts/JetBrainsMono-2.304/"
sudo cp *.ttf /Library/Fonts
cd $SCRIPT_DIR

file=/opt/homebrew/bin/brew
if [ ! -e "$file" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/mike/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

cd $SCRIPT_DIR

# Create secrets file for shell
touch ~/.zsh_env

mkdir -p /usr/local/bin/
sudo chown ${USER}:admin /usr/local/bin

ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
git config --global core.editor "subl -n -w"
mkdir -p ~/Library/Application\ Support/Sublime\ Text/Packages
rm -rf ~/Library/Application\ Support/Sublime\ Text/Packages/User
ln -s "$SCRIPT_DIR/Sublime/Packages/User" ~/Library/Application\ Support/Sublime\ Text/Packages

# Install oh-my-zsh
file=~/.oh-my-zsh/oh-my-zsh.sh
if [ ! -e "$file" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "\n\n\nRun this script again!"
    exit
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

brew update && brew upgrade


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

# Install github and git flow
brew install gh
brew install git-flow

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
brew install --cask docker

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

gcloud config configurations create odin-infra
gcloud config configurations activate odin-infra
gcloud config set account mike@useodin.com
gcloud config set project odin-infra
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

gcloud auth configure-docker
gcloud auth configure-docker us-central1-docker.pkg.dev
gcloud auth configure-docker us-docker.pkg.dev

brew install cloud-sql-proxy

# https://forum.sublimetext.com/t/package-control-not-working-at-all/29219/7
ln -sf /usr/local/Cellar/openssl@1.1/1.1.1o/lib/libcrypto.dylib /usr/local/lib/

terminal-notifier -message "Done setting up dev machine"
