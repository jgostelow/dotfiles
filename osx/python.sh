#!/bin/bash
set -e # exit on any error

basedir=$HOME/dotfiles
source $basedir/osx/functions.sh

function setup_python() {
  install 'pyenv'
  install 'pyenv-virtualenv'

  printf "${CYAN}############################################################## Installing Python\n${NC}"
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
  echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  printf "${CYAN}############################################################## Installing Django\n${NC}"
}

setup_python
