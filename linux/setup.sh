#!/bin/bash

basedir=$HOME/GIT/dotfiles

function install {
  if ! command -v $1 > /dev/null; then
    echo "###### Installing $1 ######"
    sudo apt install -y $1
  fi
}

### GENERAL ###
echo "Installing some basic things......"
sudo apt update
install 'docker'
install 'wget'
install 'ack-grep'
install 'tmux'

echo "Setting up aliases......"
echo "source $basedir/base/aliases" > ~/.aliases
echo "source $basedir/linux/aliases" >> ~/.aliases

### GIT ###
echo "Setting up git config......"
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/base/gitconfig
  path = $basedir/base/gitconfig.personal
EOF
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
ln -sf $basedir/base/.gitignore_global ~/

### VIM ###
echo "Setting up vim......"
ln -sf $basedir/base/.vim ~/
ln -sf $basedir/base/.vimrc ~/

### MISC ###
echo "Linking bin directory......"
ln -sf $basedir/base/bin ~/

### ZSH ###
#install 'zsh-antigen'
echo "Installing and switching to ZSH......"
install 'zsh'
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s `which zsh`
curl -L git.io/antigen > ~/antigen.zsh
echo "source $basedir/base/zshrc" > ~/.zshrc
echo "source $basedir/base/env" >> ~/.zshrc
/usr/bin/zsh -i -c "source ~/antigen.zsh"

echo "Linux Setup complete!"
