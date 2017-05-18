#!/bin/bash

basedir=$(pwd)

ENV=$1    # personal,wyzant

function install {
  if ! command -v $1 > /dev/null; then
    echo "###### Installing $1 ######"
    sudo apt-get install -y $1
  fi
}

### GENERAL ###
echo "Installing some basic things......"
sudo apt-get update
install 'wget'
install 'ack-grep'
install 'tmux'

echo "Setting up aliases......"
echo "source $basedir/aliases" > ~/.aliases
echo "source $basedir/linux/aliases" >> ~/.aliases

### GIT ###
echo "Setting up git config......"
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/gitconfig
EOF
if [ -n "$ENV" ] && [[ -r $basedir/gitconfig.$ENV ]]; then
  cat >> ~/.gitconfig << EOF
  path = $basedir/gitconfig.$ENV
EOF
fi
ln -sf $basedir/.gitignore_global ~/

### VIM ###
echo "Setting up vim......"
ln -sf $basedir/.vim ~/
ln -sf $basedir/.vimrc ~/
git submodule init
git submodule update

### MISC ###
echo "Setting up screen and bin directory......"
ln -sf $basedir/.screenrc ~/
ln -sf $basedir/bin ~/

### ZSH ###
#install 'zsh-antigen'
echo "Installing and switching to ZSH......"
install 'zsh'
chsh -s `which zsh`
curl -L git.io/antigen > ~/antigen.zsh
echo "source $basedir/zshrc" > ~/.zshrc
echo "source $basedir/env" >> ~/.zshrc
/usr/bin/zsh -i -c "source ~/antigen.zsh"

echo "Linux Setup complete!"
