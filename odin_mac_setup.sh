echo "Beginning setup of development tools...\n"

echo "Installing Homewbrew..."
file=/usr/local/bin/brew
if [ ! -e "$file" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
echo "Done!\n"

echo "Installing useful tools..."
brew install tree
brew install pgcli
echo "Done!\n"

echo "Installing Python dependencies..."
brew install pyenv
brew install zlib
brew install sqlite
brew install bzip2
brew install libiconv
brew install libzip
echo "Done!\n"

echo "Setting Environment Variables..."
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/sqlite/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/sqlite/include"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/sqlite/lib/pkgconfig"
echo "Done!\n"

echo "Installing Python 3.9.6..."
pyenv install 3.9.6
pyenv global 3.9.6
pyenv exec pip install --upgrade pip
echo "Done!\n"

echo "Installing Node 14.17.5..."
brew install nodenv
nodenv install 14.17.5
nodenv global 14.17.5
echo "Done!\n"

echo "Installing Docker..."
brew install --cask docker       # Install Docker
open /Applications/Docker.app    # Start Docker
echo "Done!\n"

echo "Installing Google Cloud SDK..."
brew install --cask google-cloud-sdk
echo "Done!\n"

echo "Setup of development tools complete... Bye!"
