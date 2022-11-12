#!/bin/bash

basedir=$HOME/GIT/dotfiles

function binstall {
  if ! command -v $1 > /dev/null; then
    echo "###### Installing (homebrew) $1 ######"
    brew install $1
  fi
}

function install {
  if ! command -v $1 > /dev/null; then
    echo "###### Installing (apt) $1 ######"
    sudo apt install $1
  fi
}

### GENERAL ###
echo "###### Installing homebrew"
if [ ! -f "`which brew`" ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    	echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/raziel/.profile
    	echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/raziel/.profile
    	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    	sudo apt-get install build-essential
fi
brew update > /dev/null
binstall 'vim'
binstall 'wget'
binstall 'glances'
binstall 'watch'
binstall 'tig'
binstall 'jq'
binstall 'yq'
binstall 'tmux'
binstall 'ctags'
binstall 'vifm'
binstall 'ripgrep'
binstall 'moreutils' # http://joeyh.name/code/moreutils/
binstall 'openssl'
sudo apt install 'libz-dev'

# https://www.vimfromscratch.com/articles/awesome-command-line-tools/
binstall 'tldr'
binstall 'bat'
binstall 'exa'
binstall 'fd'
binstall 'fzf'

binstall 'jandedobbeleer/oh-my-posh/oh-my-posh' # https://ohmyposh.dev/
binstall 'nodejs' # required by coc.vim

brew tap jesseduffield/lazydocker
binstall 'lazydocker'
brew tap jesseduffield/lazygit
binstall 'lazygit'
ln -sf $basedir/base/lazygit.config.yml ~/.config/lazygit/config.yml

echo "Setting up aliases......"
echo "source $basedir/base/aliases" > ~/.aliases

### GIT ###
echo "Setting up git config......"
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/base/gitconfig
EOF
binstall 'diff-so-fancy'
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
ln -sf $basedir/base/.gitignore_global ~/

### VIM ###
echo "Setting up vim......"
ln -sf $basedir/base/.vim/* ~/.vim/
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
binstall antigen
echo "source $basedir/zsh/zshrc" > ~/.zshrc
echo "source $baserdir/zsh/functions.zsh" >> ~/.zshrc

### Ruby ###
binstall 'rbenv'
binstall 'ruby-build'

echo "#### Installing Ruby 2.7 ####"
rbenv install 2.7.4
rbenv global 2.7.4
rbenv rehash

ln -sf $basedir/base/.gemrc ~/

echo "#### Installing Rails 5.2 ####"
gem install rails -v 6.1.6

echo "Linux Setup complete!"
