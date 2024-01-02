#!/bin/bash
set -e # exit on any error

basedir=$HOME/dotfiles
source $basedir/linux/functions.sh

function setup_python() {
  binstall 'pyenv'

  printf "${CYAN}############################################################## Installing Python\n${NC}"
  eval "$(pyenv init -)"
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
  echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc

  printf "${CYAN}############################################################## Installing Django\n${NC}"
  gem install rails -v 7.1.0
}

setup_python
