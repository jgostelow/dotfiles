#!/bin/bash
set -e # exit on any error

basedir=$HOME/dotfiles
CYAN='\033[0;36m'
NC='\033[0m' # No Color
export HOMEBREW_NO_INSTALL_CLEANUP=1

function binstall {
  printf "${CYAN}############################################################## BREW: Installing $1${NC}\n"
  NONINTERACTIVE=1 brew install --quiet $1
}

function install {
  printf "${CYAN}############################################################## APT : Installing $1${NC}\n"
  sudo apt-get -qq install $1 -y > /dev/null
}

function update_apt {
  sudo add-apt-repository ppa:jonathonf/vim -y > /dev/null # Vim 9
  sudo apt update -y &> /dev/null

}
function install_homebrew() {
  if [ ! -f "`which brew`" ]; then
    printf "${CYAN}############################################################## Installing homebrew${NC}\n"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    install build-essential
  fi
  brew update > /dev/null
}

function install_packages() {
  install 'wget'
  install 'glances'
  install 'watch'
  install 'jq'
  binstall 'yq'
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
  binstall 'diff-so-fancy'
  install 'tig'
  binstall 'lazygit'
  mkdir -p ~/.config/lazygit
  ln -sf $basedir/base/lazygit.config.yml ~/.config/lazygit/config.yml
  ln -sf $basedir/base/.gitignore_global ~/
}

function setup_vim() {
  printf "${CYAN}############################################################## Setting up vim......\n${NC}"
  install 'vim'
  ln -sf $basedir/base/.vim/* ~/.vim/
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vi +'PlugInstall' +qa
}

function setup_tmux() {
  printf "${CYAN}############################################################## Setting up tmux......\n${NC}"
  install 'tmux'
  ln -sf $basedir/base/.tmux.conf ~/
  echo "source-file ~/.tmux.conf" > ~/.tmate.conf
  tmux source ~/.tmux.conf
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
  echo "alias clip=clip.exe" >> ~/.zshrc " like pbcopy on windows
  binstall 'jandedobbeleer/oh-my-posh/oh-my-posh' # https://ohmyposh.dev/
}

function setup_ruby() {
  install 'rbenv'
  install 'ruby-build'

  printf "${CYAN}############################################################## Installing Ruby\n${NC}"
  rbenv install 3.2.2
  rbenv rehash
  rbenv global 3.2.2

  ln -sf $basedir/base/.gemrc ~/

  # Some packages that seem to be needed for rails functionality
  install 'libvips42' # ruby-vips - https://github.com/libvips/ruby-vips

  printf "${CYAN}############################################################## Installing Rails\n${NC}"
  gem install rails -v 7.1.0
}

function cleanup() {
  sudo apt-get autoremove -y
}

# -------------------------------------------------------------------------------------------------------------

printf "${CYAN}############################################################## Installing Homebrew/Apt packages${NC}\n"
update_apt
install_homebrew
install_packages
setup_aliases
setup_git
setup_vim
setup_tmux
setup_zsh
setup_ruby
cleanup
printf "${CYAN}############################################################## Linux Setup complete! \n${NC}"
printf "${CYAN}############################################################## Switching to ZSH \n${NC}"
chsh -s `which zsh`
