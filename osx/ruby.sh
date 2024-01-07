#!/bin/bash
set -e # exit on any error

basedir=$HOME/dotfiles
source $basedir/osx/functions.sh

function setup_ruby() {
  install 'rbenv'
  install 'ruby-build'

  printf "${CYAN}############################################################## Installing Ruby\n${NC}"
  rbenv install 3.2.2 --skip-existing
  rbenv global 3.2.2
  rbenv rehash

  ln -sf $basedir/base/.gemrc ~/

  printf "${CYAN}############################################################## Installing Rails\n${NC}"
  gem install rails -v 7.1.0
}
# -------------------------------------------------------------------------------------------------------------

setup_ruby
