#!/bin/bash

basedir=$(pwd)

OS_MAP=(
  "Linux:linux"
  "Darwin:osx"
)

OS=OS_MAP[`uname`]
SHELL=$1  # zsh, bash
ENV=$2    # personal,groupon

### GENERAL ###
echo "source $basedir/.aliases.base" > ~/.aliases
[ -n "$OS" ] && [[ -r $basedir/.aliases.$OS ]] && echo "source $basedir/.aliases.$OS" >> ~/.aliases

case $SHELL in
  zsh)
### ZSH ###
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/antigen.zsh
echo "source $basedir/.zshrc" > ~/.zshrc
echo "source $basedir/.env" >> ~/.zshrc
chsh -s `which zsh`
;;
  bash)
### BASH ###
echo "source $basedir/.bash_profile.base" > ~/.bash_profile
[ -n "$ENV" ] && [[ -r $basedir/.bash_profile.$ENV ]] && echo "source $basedir/.bash_profile.$ENV" >> ~/.bash_profile
echo "source $basedir/.env" >> ~/.bash_profile
source ~/.bash_profile
chsh -s `which bash`
;;
esac

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

### VIM ###
ln -sf $basedir/.vim ~/
ln -sf $basedir/.vimrc ~/
git submodule init
git submodule update

### MISC ###
ln -sf $basedir/.screenrc ~/

