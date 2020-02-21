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
sudo apt update > /dev/null
install 'docker'
install 'wget'
install 'silversearcher-ag'
install 'tmux'
install 'tig'
install 'jq'
install 'yq'
install 'tldr'

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

### Install git submodules - typically plugins for vim and tmux
git submodule init
git submodule update

### VIM ###
echo "Setting up vim......"
ln -sf $basedir/base/.vim ~/

### TMUX ###
echo "Setting up tmux......"
ln -sf $basedir/base/.tmux ~/
ln -sf $basedir/base/.tmux.conf ~/
tmux source ~/.tmux.conf

### ZSH ###
#install 'zsh-antigen'
echo "Installing and switching to ZSH......"
install 'zsh'
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -sf $basedir/base/jono.zsh-theme ~/.oh-my-zsh/themes/
chsh -s `which zsh`
curl -L git.io/antigen > ~/antigen.zsh
echo "source $basedir/base/zshrc" > ~/.zshrc
/usr/bin/zsh -i -c "source ~/antigen.zsh"

echo "Linux Setup complete!"
