#!/bin/bash

basedir=$(pwd)

SHELL=$1  # zsh, bash
ENV=$2    # personal,groupon,wyzant

function install {
  if ! command -v $1 > /dev/null; then
    sudo apt-get install $1
  fi
}

### GENERAL ###
sudo apt-get update
install 'wget'
install 'ack-grep'

echo "source $basedir/.aliases.base" > ~/.aliases
[[ -r $basedir/.aliases.linux ]] && echo "source $basedir/.aliases.linux" >> ~/.aliases

### GIT ###
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/.gitconfig.base
EOF
if [ -n "$ENV" ] && [[ -r $basedir/.gitconfig.$ENV ]]; then
  cat >> ~/.gitconfig << EOF
  path = $basedir/.gitconfig.$ENV
EOF
fi
ln -sf $basedir/.gitignore_global ~/
install 'hub'
install 'git-flow'
echo "source $basedir/.aliases.gitflow" > ~/.aliases

### VIM ###
ln -sf $basedir/.vim ~/
ln -sf $basedir/.vimrc ~/
git submodule init
git submodule update

### MISC ###
ln -sf $basedir/.screenrc ~/
ln -sf $basedir/bin ~/

case $SHELL in
  zsh)
  ### ZSH ###
  install 'zsh-antigen'
  echo "source $basedir/.zshrc" > ~/.zshrc
  echo "source $basedir/.env" >> ~/.zshrc
  if ! echo $ZSH_VERSION < /dev/null; then
    chsh -s `which zsh`
  fi
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

