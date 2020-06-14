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
echo "Updating apt repositories"
sudo apt update > /dev/null
install 'wget'
install 'silversearcher-ag'
install 'tmux'
install 'tig'
install 'jq'
install 'tldr'
install 'nodejs' # required by coc.vim
install 'fish'

### FISH ###
echo "Changing to fish"
chsh -s `which fish`
# https://github.com/jorgebucaran/fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish


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
vim +'PlugInstall -s --sync' +qa

### TMUX ###
echo "Setting up tmux......"
ln -sf $basedir/base/.tmux ~/
ln -sf $basedir/base/.tmux.conf ~/
tmux source ~/.tmux.conf

echo "Linux Setup complete!"
