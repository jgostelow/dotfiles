#!/bin/bash
set -e # exit on any error

basedir=$HOME/dotfiles
source $basedir/linux/functions.sh

function setup_ruby() {
  install 'rbenv'
  binstall 'ruby-build'
  eval "$(rbenv init -)"

  printf "${CYAN}############################################################## Installing Ruby\n${NC}"
  rbenv install 3.2.2 --skip-existing
  rbenv global 3.2.2
  rbenv rehash
  echo "eval \"$(rbenv init - zsh)\"" >> ~/.zshrc

  ln -sf $basedir/base/.gemrc ~/

  # Some packages that seem to be needed for rails functionality
  install 'libvips42' # ruby-vips - https://github.com/libvips/ruby-vips

  printf "${CYAN}############################################################## Installing Rails\n${NC}"
  gem install rails -v 7.1.0
}

setup_ruby
