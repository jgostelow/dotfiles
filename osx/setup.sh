#!/bin/bash
set -e # exit on any error

basedir=$HOME/dotfiles
CYAN='\033[0;36m'
NC='\033[0m' # No Color
export HOMEBREW_NO_INSTALL_CLEANUP=1

function install {
  printf "${CYAN}############################################################## BREW: Installing $1${NC}\n"
  NONINTERACTIVE=1 brew install --quiet $1
}

function install_homebrew() {
	printf "${CYAN}############################################################## Installing+Updating homebrew${NC}\n"
	[ ! -f "`which brew`" ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update > /dev/null
}


function install_packages() {
		install 'wget'
		install 'glances'
		install 'watch'
		install 'jq' # https://stedolan.github.io/jq/
		install 'yq' # https://github.com/mikefarah/yq
		install 'stern'
		install 'ctags'
		install 'vifm'
		install 'ripgrep'
		install 'moreutils' # http://joeyh.name/code/moreutils/

  brew tap homebrew/cask-fonts
  install 'font-cascadia-code'

# https://www.vimfromscratch.com/articles/awesome-command-line-tools/
		install 'tldr'
		install 'bat'
		install 'exa'
		install 'fd'
		install 'fzf'
		install 'dust'
		install 'duf'
		install 'mcfly'
		install 'doitlive' # https://doitlive.readthedocs.io/en/stable/

		install 'nodejs' # required by coc.vim

		brew tap jesseduffield/lazydocker
		install 'lazydocker'
		brew tap jesseduffield/lazygit
		install 'lazygit'
}

function setup_aliases() {
  printf "${CYAN}############################################################## Setting up aliases......\n${NC}"
  echo "source $basedir/base/aliases" > ~/.aliases
}

function setup_git() {
  printf "${CYAN}############################################################## Setting up git config......\n${NC}"
  git config --global user.email "jonathan.gostelow@gmail.com"
  git config --global user.name "Jonathan Gostelow"
  git config --global --replace-all include.path $basedir/base/gitconfig
  install 'diff-so-fancy'
  install 'tig'
  install 'lazygit'
  mkdir -p ~/.config/lazygit
  ln -sf $basedir/base/lazygit.config.yml ~/.config/lazygit/config.yml
  ln -sf $basedir/base/.gitignore_global ~/
}

function setup_vim() {
  printf "${CYAN}############################################################## Setting up vim......\n${NC}"
  install 'vim'
  ln -sf $basedir/base/.vim ~/.vim
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vi +'PlugInstall' +qa
}

function setup_tmux() {
  printf "${CYAN}############################################################## Setting up tmux......\n${NC}"
  install 'tmux'
  ln -sf $basedir/base/.tmux.conf ~/
  echo "source-file ~/.tmux.conf" > ~/.tmate.conf
  if [ ! -d ~/.tmux/plugins/tpm ] ; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

function setup_zsh() {
  printf "${CYAN}############################################################## Installing zsh + oh-my-zsh \n${NC}"
  install 'zsh'
  if [ ! -d $ZSH ] ; then
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" --unattended
  fi
  if [ ! -f $HOME/antigen.zsh ] ; then
    curl -L git.io/antigen > $HOME/antigen.zsh
  fi
  echo "source $basedir/zsh/zshrc" > ~/.zshrc
  echo "source $HOME/dotfiles/zsh/functions.zsh" >> ~/.zshrc
  install 'jandedobbeleer/oh-my-posh/oh-my-posh' # https://ohmyposh.dev/
  oh-my-posh font install
  /bin/zsh -i -c "source ~/antigen.zsh"
}

function setup_ruby() {
  install 'rbenv'
  install 'ruby-build'

  printf "${CYAN}############################################################## Installing Ruby\n${NC}"
  rbenv install 3.2.2 --skip-existing
  rbenv global 3.2.2
  rbenv rehash

  ln -sf $basedir/base/.gemrc ~/

  printf "${CYAN}############################################################## Installing Rails\n${NC}"
  gem install rails -v 7.1.0
}

function misc() {

  printf "${CYAN}############################################################## Linking ~/bin\n${NC}"
  ln -sf $basedir/bin ~/
}

function cleanup() {
}

# -------------------------------------------------------------------------------------------------------------

install_homebrew
install_packages
setup_aliases
setup_git
setup_vim
setup_tmux
setup_zsh
setup_ruby
misc
cleanup
printf "${CYAN}############################################################## Linux Setup complete! \n${NC}"
printf "${CYAN}############################################################## Switching to ZSH \n${NC}"
chsh -s `which zsh`
