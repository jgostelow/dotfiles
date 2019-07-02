#!/bin/bash

basedir=$HOME/GIT/dotfiles

function binstall {
  if ! command -v $1 > /dev/null; then
    echo "###### Installing $1 ######"
    brew install $1
  fi
}

### GENERAL ###
echo "Installing Homebrew and some basic things......"
[ ! -f "`which brew`" ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update > /dev/null
brew cask install docker
brew cask install firefox
brew cask install postman
brew cask install slack
brew cask install bettertouchtool
binstall 'wget'
binstall 'tig'
binstall 'jq' #https://stedolan.github.io/jq/
binstall 'stern'
binstall 'tmux'
binstall 'vifm'
binstall 'ctags'
binstall 'the_silver_searcher'
binstall 'moreutils' # http://joeyh.name/code/moreutils/

brew tap jesseduffield/lazydocker
binstall 'lazydocker'

echo "source $basedir/base/aliases" > ~/.aliases
echo "source $basedir/osx/aliases" >> ~/.aliases

### GIT ###
echo "Setting up git config......"
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/base/gitconfig
  path = $basedir/base/gitconfig.personal
EOF
ln -sf $basedir/base/.gitignore_global ~/
binstall 'hub'

### Install git submodules - typically plugins for vim and tmux
git submodule init
git submodule update

### VIM ###
echo "Setting up vim......"
ln -sf $basedir/base/.vim ~/

### TMUX ###
echo "Setting up tmux......"
ln -sf $basedir/base/.tmux ~/
ln -sf $basedir/base/.tmux.conf ~/
tmux source ~/.tmux.conf

### MISC ###
echo "Linking bin directory......"
ln -sf $basedir/bin ~/

### ZSH ###
echo "Installing and switching to ZSH......"
binstall 'zsh'
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s `which zsh`
(curl -L git.io/antigen > ~/antigen.zsh) &> /dev/null
echo "source $basedir/base/zshrc" > ~/.zshrc
/bin/zsh -i -c "source ~/antigen.zsh"

### Ruby ###
binstall 'rbenv'
binstall 'ruby-build'

echo "#### Installing Ruby 2.5 ####"
rbenv install 2.5.3
rbenv global 2.5.3
rbenv rehash

echo "#### Installing Rails 5.2 ####"
gem install rails -v 5.2.1

### MySQL ###
binstall 'mysql@5.7'
brew link --force mysql@5.7
brew services start mysql@5.7
# Run this when bundle installing in specific repo
# bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include"
gem install mysql2

## Golang ###
binstall 'go'

ln -sf $basedir/base/.gemrc ~/

echo "OSX Setup complete!"
