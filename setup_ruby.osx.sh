#!/bin/bash

basedir=$(pwd)

function install {
  if ! command -v $1 > /dev/null; then
    echo "#### Installing $1 ####"
    brew install $1
  fi
}

install 'rbenv'
install 'ruby-build'

source $basedir/.env

echo "#### Installing Ruby 2.4.0 ####"
rbenv install 2.4.0
rbenv global 2.4.0

echo "#### Installing Rails 5.0.1 ####"
gem install rails -v 5.0.1
rbenv rehash

## Postgres
install 'postgresql'
ln -sfv /usr/local/opt/postgresql/*plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
createdb `whoami`
