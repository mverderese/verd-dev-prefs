#!/usr/bin/env zsh

xcode-select -p &>/dev/null || xcode-select --install

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SCRIPT_DIR/Fonts/JetBrainsMono-2.304/"
sudo cp *.ttf /Library/Fonts
cd $SCRIPT_DIR

if [[ $(uname -m) == 'arm64' ]]; then
    homebrew_location=/opt/homebrew/bin/brew
else
    homebrew_location=/usr/local/bin/brew
fi

if [ ! -e "$homebrew_location" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(${homebrew_location} shellenv)"') >> /Users/mike/.zprofile
    eval "$(${homebrew_location} shellenv)"
fi

cd $SCRIPT_DIR

mkdir -p /usr/local/bin/
sudo chown ${USER}:admin /usr/local/bin

# Install oh-my-zsh
file=~/.oh-my-zsh/oh-my-zsh.sh
if [ ! -e "$file" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "\n\n\nRun this script again!"
    exit
fi

[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

brew update && brew upgrade

# Create symbolic links for dotfiles
cd ~/

rm -f ./.zshrc
ln -s "$SCRIPT_DIR/dotfiles/dotzshrc" ~/.zshrc

rm -f ./.gitconfig
ln -s "$SCRIPT_DIR/dotfiles/dotgitconfig" ~/.gitconfig

rm -f ./.oh-my-zsh/themes/mverderese.zsh-theme
ln -s "$SCRIPT_DIR/dotfiles/mverderese.zsh-theme" ~/.oh-my-zsh/themes/mverderese.zsh-theme


brew install --quiet fnm
brew install --quiet uv
brew install --quiet gh
brew install --quiet terminal-notifier
brew install --quiet speedtest_cli
brew install --quiet tree
brew install --quiet tmux
brew install --quiet tig
brew install --quiet ffmpeg
brew install --quiet pgcli

brew install --cask google-cloud-sdk
brew install --cask docker

# Install/update latest LTS Node via fnm and pin as default
fnm install --lts
fnm default lts-latest
fnm use lts-latest
npm update -g
npm install -g @anthropic-ai/claude-code

# Install/update latest Python via uv and pin as default
uv python install 3
uv python pin $(uv python list --only-installed | grep -oE '3\.[0-9]+\.[0-9]+' | head -1)

gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null | grep -q . || gcloud auth login
gcloud config set project verderese-development

npm install -g @googleworkspace/cli
[ ! -f "$HOME/.config/gws/credentials.enc" ] && gws auth setup
[ ! -f "$HOME/.config/gws/token_cache.json" ] && gws auth login

terminal-notifier -message "Done setting up dev machine"
