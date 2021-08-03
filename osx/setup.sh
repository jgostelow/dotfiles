#!/bin/bash

basedir=$HOME/GIT/dotfiles

function binstall {
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
binstall 'vim'
binstall 'wget'
binstall 'htop'
binstall 'glances'
binstall 'watch'
binstall 'tig'
binstall 'jq' # https://stedolan.github.io/jq/
binstall 'yq' # https://github.com/mikefarah/yq
binstall 'stern'
binstall 'tmux'
binstall 'vifm'
binstall 'ctags'
binstall 'the_silver_searcher'
binstall 'moreutils' # http://joeyh.name/code/moreutils/
binstall 'reattach-to-user-namespace' # https://thoughtbot.com/blog/tmux-copy-paste-on-os-x-a-better-future
binstall 'doitlive' # https://doitlive.readthedocs.io/en/stable/

# https://www.vimfromscratch.com/articles/awesome-command-line-tools/
binstall 'tldr'
binstall 'diff-so-fancy'
binstall 'bat'
binstall 'exa'
binstall 'fd'
binstall 'fzf'

binstall 'starship'

brew tap jesseduffield/lazydocker
binstall 'lazydocker'

# Node
# curl -sL install-node.now.sh/lts | bash

echo "source $basedir/base/aliases" > ~/.aliases
echo "source $basedir/osx/aliases" >> ~/.aliases

### GIT ###
echo "Setting up git config......"
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/base/gitconfig
  path = $basedir/base/gitconfig.personal
EOF
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
ln -sf $basedir/base/.gitignore_global ~/
binstall 'hub'

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
echo "source-file ~/.tmux.conf" > ~/.tmate.conf
tmux source ~/.tmux.conf

### MISC ###
echo "Linking bin directory......"
ln -sf $basedir/bin ~/

### ZSH ###
# echo "Installing and switching to ZSH......"
# binstall 'zsh'
# sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# ln -sf $basedir/zsh/jono.zsh-theme ~/.oh-my-zsh/themes/
# chsh -s `which zsh`
# (curl -L git.io/antigen > ~/antigen.zsh) &> /dev/null
# echo "source $basedir/zsh/zshrc" > ~/.zshrc
# echo "source $baserdir/zsh/functions.zsh" >> ~/.zshrc
# /bin/zsh -i -c "source ~/antigen.zsh"

### FISH ###
echo "Changing to fish"
binstall 'fish'
chsh -s `which fish`

echo "source ~/.aliases" >> ~/.config/fish/config.fish
echo "source $baserdir/fish/config.fish" >> ~/.config/fish/config.fish

ln -sf $basedir/fish/fishfile ~/.config/fish/
fisher

ln -sf $baserdir/base/startship.toml ~/.config/

### Ruby ###
binstall 'rbenv'
binstall 'ruby-build'

echo "#### Installing Ruby 2.5 ####"
rbenv install 2.5.3
rbenv global 2.5.3
rbenv rehash

ln -sf $basedir/base/.gemrc ~/

echo "#### Installing Rails 5.2 ####"
gem install rails -v 5.2.1

### MySQL ###
binstall 'mysql@5.7'
brew link --force mysql@5.7
brew services start mysql@5.7
# Run this when bundle installing in specific repo
# bundle config --local build.mysql2 "--with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include"
gem install mysql2

## Golang ###
# binstall 'gvm'
# gvm install go1.13
# gvm use go1.13 --default

echo "OSX Setup complete!"
