#!/bin/bash

basedir=$HOME/GIT/dotfiles

function install {
  if ! command -v $1 > /dev/null; then
    echo "###### Installing $1 ######"
    brew install $1
  fi
}

### GENERAL ###
echo "Installing Homebrew and some basic things......"
[ ! -f "`which brew`" ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update > /dev/null
brew install --cask docker
brew install --cask firefox
brew install --cask postman
brew install --cask slack
brew install --cask bettertouchtool
install 'vim'
install 'wget'
install 'glances'
install 'watch'
install 'tig'
install 'jq' # https://stedolan.github.io/jq/
install 'yq' # https://github.com/mikefarah/yq
install 'stern'
install 'tmux'
install 'ctags'
install 'ripgrep'
install 'moreutils' # http://joeyh.name/code/moreutils/

# https://www.vimfromscratch.com/articles/awesome-command-line-tools/
install 'tldr'
install 'bat'
install 'exa'
install 'fd'
install 'fzf'

install 'starship'
install 'nodejs' # required by coc.vim

brew tap jesseduffield/lazydocker
install 'lazydocker'

# Reserve
# install 'doitlive' # https://doitlive.readthedocs.io/en/stable/
# install 'vifm'

echo "Setting up aliases......"
echo "source $basedir/base/aliases" > ~/.aliases
echo "source $basedir/osx/aliases" >> ~/.aliases

### GIT ###
echo "Setting up git config......"
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/base/gitconfig
  path = $basedir/base/gitconfig.personal
EOF
install 'diff-so-fancy'
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
ln -sf $basedir/base/.gitignore_global ~/

### VIM ###
echo "Setting up vim......"
ln -sf $basedir/base/.vim ~/
vim +'PlugInstall' +qa

### TMUX ###
echo "Setting up tmux......"
ln -sf $basedir/base/.tmux ~/
ln -sf $basedir/base/.tmux.conf ~/
echo "source-file ~/.tmux.conf" > ~/.tmate.conf
tmux source ~/.tmux.conf

### ZSH ###
echo "Installing to zsh + oh-my-zsh"
install 'zsh'
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s `which zsh`
(curl -L git.io/antigen > ~/antigen.zsh) &> /dev/null
echo "source $basedir/zsh/zshrc" > ~/.zshrc
echo "source $baserdir/zsh/functions.zsh" >> ~/.zshrc
/bin/zsh -i -c "source ~/antigen.zsh"
ln -sf $baserdir/base/starship.toml ~/.config/

### Ruby ###
install 'rbenv'
install 'ruby-build'

echo "#### Installing Ruby 2.5 ####"
rbenv install 3.1.2
rbenv global 3.1.2
rbenv rehash

ln -sf $basedir/base/.gemrc ~/

### MISC ###
echo "Linking bin directory......"
ln -sf $basedir/bin ~/


echo "OSX Setup complete!"
