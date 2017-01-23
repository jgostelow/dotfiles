#!/bin/bash

basedir=$(pwd)

OS_MAP=(
  "Linux:linux"
  "Darwin:osx"
)

OS=OS_MAP[`uname`]
SHELL=$1  # zsh, bash
ENV=$2    # personal,groupon,wyzant

function brew_install {
  if ! command -v $1 > /dev/null; then
    brew install $1
  fi
}

### GENERAL ###
if ! type "brew" > /dev/null; then # Homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew update
brew_install 'wget'

echo "source $basedir/.aliases.base" > ~/.aliases
[ -n "$OS" ] && [[ -r $basedir/.aliases.$OS ]] && echo "source $basedir/.aliases.$OS" >> ~/.aliases

case $SHELL in
  zsh)
  ### ZSH ###
  brew_install 'antigen'
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

### GIT ###
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/.gitconfig.base
EOF
if [ -n "$ENV" ]; then
  touch $HOME/.gitconfig.$ENV
  cat >> ~/.gitconfig << EOF
  path = $HOME/.gitconfig.$ENV
EOF
fi
ln -sf $basedir/.gitignore_global ~/
brew_install 'hub'

### VIM ###
ln -sf $basedir/.vim ~/
ln -sf $basedir/.vimrc ~/
git submodule init
git submodule update

### MISC ###
ln -sf $basedir/.screenrc ~/

