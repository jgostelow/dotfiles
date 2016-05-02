#!/bin/bash

basedir=$(pwd)

OS=$1 # osx,linux
ENV=$2 # home,groupon

### ZSH ###
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "source $basedir/.zshrc" > ~/.zshrc

### BASH ###
echo "source $basedir/.aliases.base" > ~/.aliases
[ -n "$OS" ] && [[ -r $basedir/.aliases.$OS ]] && echo "source $basedir/.aliases.$OS" >> ~/.aliases

echo "source $basedir/.bash_profile.base" > ~/.bash_profile
[ -n "$ENV" ] && [[ -r $basedir/.bash_profile.$ENV ]] && echo "source $basedir/.bash_profile.$ENV" >> ~/.bash_profile
echo "source ~/.aliases" >> ~/.bash_profile
source ~/.bash_profile

### GIT ###
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/.gitconfig.base
EOF
if [ -n "$ENV" ]; then 
  cat >> ~/.gitconfig << EOF
  path = $basedir/.gitconfig.$ENV
EOF
fi
ln -sf $basedir/.gitignore_global ~/

ln -sf $basedir/.screenrc ~/
ln -sf $basedir/.vim ~/
ln -sf $basedir/.vimrc ~/
git submodule init
git submodule update
