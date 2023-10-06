#!/bin/bash

basedir=$HOME/dotfiles
CYAN='\033[0;36m'
NC='\033[0m' # No Color
HOMEBREW_NO_INSTALL_CLEANUP=1

function binstall {
	if ! command -v $1 > /dev/null; then
		printf "${CYAN}############################################################## BREW: Installing $1${NC}\n"
		NONINTERACTIVE=1 brew install --quiet $1
	fi
}

function install {
	if ! command -v $1 > /dev/null; then
		printf "${CYAN}##############################################################  APT : Installing $1${NC}\n"
		sudo apt -qq install $1 -y
	fi
}

### GENERAL ###
sudo add-apt-repository ppa:jonathonf/vim -y > /dev/null # Vim 9

printf "${CYAN}############################################################## Installing Homebrew packages${NC}\n"
sudo apt update -y &> /dev/null
if [ ! -f "`which brew`" ]; then
	printf "${CYAN}############################################################## Installing homebrew${NC}\n"
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	install build-essential
fi
brew update > /dev/null

install 'vim'
install 'wget'
install 'glances'
install 'watch'
install 'tig'
install 'jq'
binstall 'yq'
install 'tmux'
install 'ctags'
install 'vifm'
install 'ripgrep'
install 'moreutils' # http://joeyh.name/code/moreutils/
install 'openssl'
install 'libz-dev'

# https://www.vimfromscratch.com/articles/awesome-command-line-tools/
install 'tldr'
install 'bat'
binstall 'exa'
binstall 'fd'
install 'fzf'

install 'nodejs' # required by coc.vim

brew tap cantino/mcfly
binstall 'cantino/mcfly/mcfly'
brew tap jesseduffield/lazydocker
binstall 'lazydocker'
brew tap jesseduffield/lazygit
binstall 'lazygit'
mkdir -p ~/.config/lazygit
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
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vi +'PlugInstall' +qa

### TMUX ###
printf "${CYAN}############################################################## Setting up tmux......\n${NC}"
ln -sf $basedir/base/.tmux.conf ~/
echo "source-file ~/.tmux.conf" > ~/.tmate.conf
tmux source ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### ZSH ###
printf "${CYAN}############################################################## Installing zsh + oh-my-zsh \n${NC}"
install 'zsh'
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" --unattended
curl -L git.io/antigen > $HOME/antigen.zsh
echo "source $basedir/zsh/zshrc" >> ~/.zshrc
echo "source $basedir/zsh/functions.zsh" >> ~/.zshrc
binstall 'jandedobbeleer/oh-my-posh/oh-my-posh' # https://ohmyposh.dev/

### Ruby ###
install 'rbenv'
install 'ruby-build'

printf "${CYAN}############################################################## Installing Ruby 2.7 \n${NC}"
rbenv install 3.2.2
rbenv global 3.2.2
rbenv rehash

ln -sf $basedir/base/.gemrc ~/

printf "${CYAN}############################################################## Installing Rails 5.2 \n${NC}"
gem install rails -v 7.1.0

printf "${CYAN}############################################################## Linux Setup complete! \n${NC}"
printf "${CYAN}############################################################## Switching to ZSH \n${NC}"
chsh -s `which zsh`
