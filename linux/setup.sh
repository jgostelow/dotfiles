#!/bin/bash
set -e # exit on any error

basedir=$HOME/dotfiles
source $basedir/linux/functions.sh

function update_apt {
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
  printf "${CYAN}############################################################## Installing Homebrew/Apt packages${NC}\n"
  install 'wget'
  install 'glances'
  install 'watch'
  install 'jq'
  binstall 'yq'
  install 'universal-ctags'
  install 'vifm'
  install 'ripgrep'
  install 'moreutils' # http://joeyh.name/code/moreutils/
  install 'openssl'
  install 'libz-dev'

  # https://www.vimfromscratch.com/articles/awesome-command-line-tools/
  install 'tldr'
  install 'bat'
  binstall 'eza'
  binstall 'fd'
  install 'fzf'
  binstall 'dust'

  binstall 'mcfly'
  brew tap jesseduffield/lazydocker
  binstall 'lazydocker'
  brew tap jesseduffield/lazygit
}

function setup_aliases() {
  printf "${CYAN}############################################################## Setting up aliases......\n${NC}"
  add_to_file_unique "source $basedir/base/aliases" ~/.aliases
  add_to_file_unique "source $basedir/linux/aliases" ~/.aliases
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
  ln -sf $basedir/base/gitignore_global ~/.gitignore_global
}

function install_node() {
  printf "${CYAN}############################################################## Installing v21.x Nodejs......\n${NC}"
  install 'ca-certificates'
  install 'curl'
  install 'gnupg'
  sudo mkdir -p /etc/apt/keyrings
  NODE_MAJOR=21
  if [ ! -f /etc/apt/keyrings/nodesource.gpg ] ; then
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
  fi
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
  sudo apt-get update
  install 'nodejs' # required by coc.vim

}

function setup_vim() {
  printf "${CYAN}############################################################## Setting up vim......\n${NC}"
  install 'vim'
  ln -sf $basedir/base/.vim ~/
  printf "${CYAN}Ignore the error saying ' Cannot find color scheme'. Just hit Enter\n${NC}"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vi +'PlugInstall' +qa
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
  add_to_file_unique "source $basedir/zsh/zshrc" ~/.zshrc
  touch ~/.zsh_history # for mcfly
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  binstall 'jandedobbeleer/oh-my-posh/oh-my-posh' # https://ohmyposh.dev/
  /bin/zsh -i -c "source ~/antigen.zsh"
}

function setup_tmux() {
  printf "${CYAN}############################################################## Setting up tmux......\n${NC}"
  install 'tmux'
  install 'xdg-utils' # needed by tmux-open

  checkout_or_update_git_repo https://github.com/gpakosz/.tmux.git ~/.tmux master
  ln -s -f .tmux/.tmux.conf ~/
  ln -sf $basedir/base/.tmux.conf.local ~/
  add_to_file_unique "source-file ~/.tmux.conf" ~/.tmate.conf
}

update_apt
install_homebrew
install_packages
setup_aliases
setup_git
install_node
setup_vim
setup_zsh
setup_tmux
cleanup

printf "${CYAN}############################################################## Switching to ZSH \n${NC}"

chsh -s `which zsh`
printf "${CYAN}############################################################## Linux Setup complete! \n${NC}"
