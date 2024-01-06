#!/bin/bash
set -e # exit on any error

basedir=$HOME/dotfiles
source $basedir/linux/functions.sh

function setup_python() {
  binstall 'pyenv'
  install 'python3-venv'
  binstall 'pyenv-virtualenv'

  printf "${CYAN}############################################################## Installing Python\n${NC}"
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
  echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
  eval "$(pyenv init -)"
  echo "$(pyenv virtualenv-init -)"

  pyenv install 3.11
  pyenv global 3.11
  pyenv rehash

  printf "${CYAN}############################################################## Installing Django\n${NC}"
}

setup_python
