#!/bin/bash

basedir=$HOME/GIT/dotfiles

function install {
  if ! command -v $1 > /dev/null; then
    echo "###### Installing $1 ######"
    brew install $1
  fi
}

### GENERAL ###
echo "###### Installing homebrew"
[ ! -f "`which brew`" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update > /dev/null
install 'vim'
install 'wget'
install 'glances'
install 'tig'
install 'jq'
install 'yq'
install 'tmux'
install 'ctags'
install 'vifm'
install 'ripgrep'
install 'moreutils' # http://joeyh.name/code/moreutils/

# https://www.vimfromscratch.com/articles/awesome-command-line-tools/
install 'tldr'
install 'bat'
install 'exa'
install 'fd'
install 'fzf'

install 'jandedobbeleer/oh-my-posh/oh-my-posh' # https://ohmyposh.dev/
install 'nodejs' # required by coc.vim

brew tap jesseduffield/lazydocker
install 'lazydocker'
brew tap jesseduffield/lazygit
install 'lazygit'
ln -sf $basedir/base/lazygit.config.yml ~/.config/lazygit/config.yml

echo "Setting up aliases......"
echo "source $basedir/base/aliases" > ~/.aliases

### GIT ###
echo "Setting up git config......"
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/base/gitconfig
EOF
install 'diff-so-fancy'
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
ln -sf $basedir/base/.gitignore_global ~/

### VIM ###
echo "Setting up vim......"
ln -sf $basedir/base/.vim/* ~/.vim/
vim +'PlugInstall' +qa

### TMUX ###
echo "Setting up tmux......"
ln -sf $basedir/base/.tmux.conf ~/
echo "source-file ~/.tmux.conf" > ~/.tmate.conf
tmux source ~/.tmux.conf

### ZSH ###
echo "Installing to zsh + oh-my-zsh"
install 'zsh'
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s `which zsh`
install antigen
echo "source $basedir/zsh/zshrc" > ~/.zshrc
echo "source $baserdir/zsh/functions.zsh" >> ~/.zshrc

### Ruby ###
install 'rbenv'
install 'ruby-build'

echo "#### Installing Ruby 2.7 ####"
rbenv install 2.7.4
rbenv global 2.7.4
rbenv rehash

ln -sf $basedir/base/.gemrc ~/

echo "#### Installing Rails 5.2 ####"
gem install rails -v 6.1.6

echo "Windows Setup complete!"
