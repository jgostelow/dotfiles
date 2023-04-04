#!/bin/bash

basedir=$HOME/dotfiles
CYAN='\033[0;36m'
NC='\033[0m' # No Color
HOMEBREW_NO_INSTALL_CLEANUP=1

function binstall {
	if ! command -v $1 > /dev/null; then
		printf "${CYAN}############################################################## BREW: Installing $1${NC}\n"
		brew install $1
	fi
}

function install {
	if ! command -v $1 > /dev/null; then
		printf "${CYAN}##############################################################  APT : Installing $1${NC}\n"
		sudo apt install $1
	fi
}

### GENERAL ###
sudo apt update &> /dev/null
if [ ! -f "`which brew`" ]; then
	printf "${CYAN}############################################################## Installing homebrew${NC}\n"
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
install 'libz-dev'

# https://www.vimfromscratch.com/articles/awesome-command-line-tools/
binstall 'tldr'
binstall 'bat'
binstall 'exa'
binstall 'fd'
binstall 'fzf'

binstall 'nodejs' # required by coc.vim

brew tap jesseduffield/lazydocker
binstall 'lazydocker'
brew tap jesseduffield/lazygit
binstall 'lazygit'
ln -sf $basedir/base/lazygit.config.yml ~/.config/lazygit/config.yml

printf "${CYAN}############################################################## Setting up aliases......\n${NC}"
echo "source $basedir/base/aliases" > ~/.aliases

### GIT ###
printf "${CYAN}############################################################## Setting up git config......\n${NC}"
cat > ~/.gitconfig << EOF
[include]
  path = $basedir/base/gitconfig
EOF
binstall 'diff-so-fancy'
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
ln -sf $basedir/base/.gitignore_global ~/

### VIM ###
printf "${CYAN}############################################################## Setting up vim......\n${NC}"
ln -sf $basedir/base/.vim/* ~/.vim/
mkdir ~/.vim/swapfiles
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vi +'PlugInstall' +qa

### TMUX ###
printf "${CYAN}############################################################## Setting up tmux......\n${NC}"
ln -sf $basedir/base/.tmux.conf ~/
echo "source-file ~/.tmux.conf" > ~/.tmate.conf
tmux source ~/.tmux.conf

### ZSH ###
printf "${CYAN}############################################################## Installing to zsh + oh-my-zsh \n${NC}"
install 'zsh'
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
install zsh-antigen
echo "source $basedir/zsh/zshrc" > ~/.zshrc
echo "source $baserdir/zsh/functions.zsh" >> ~/.zshrc
binstall 'jandedobbeleer/oh-my-posh/oh-my-posh' # https://ohmyposh.dev/

### Ruby ###
binstall 'rbenv'
binstall 'ruby-build'

printf "${CYAN}############################################################## Installing Ruby 2.7 \n${NC}"
rbenv install 2.7.4
rbenv global 2.7.4
rbenv rehash

ln -sf $basedir/base/.gemrc ~/

printf "${CYAN}############################################################## Installing Rails 5.2 \n${NC}"
gem install rails -v 6.1.6

printf "${CYAN}############################################################## Linux Setup complete! \n${NC}"
printf "${CYAN}############################################################## Switching to ZSH \n${NC}"
chsh -s `which zsh`
