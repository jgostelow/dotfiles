#!/bin/bash
set -e # exit on any error

basedir=$HOME/dotfiles
source $basedir/linux/functions.sh

function update_apt {
  sudo apt-get update -y &> /dev/null
}

function install_homebrew() {
  if [ ! -f "`which brew`" ]; then
    h2 "Installing homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
    install build-essential
  fi
  brew update > /dev/null
}

function install_packages() {
  h2 "Installing Homebrew/Apt packages"
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
  install 'duf'
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
  h2 "Setting up aliases......"
  add_to_file_unique "source $basedir/base/aliases" ~/.aliases
  add_to_file_unique "source $basedir/linux/aliases" ~/.aliases
}

function setup_git() {
  h2 "Setting up git config......"
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
  h2 "Installing v21.x Nodejs......"
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
  h2 "Setting up vim......"
  install 'vim'
  ln -sf $basedir/base/.vim ~/
  printf "${ORANGE}Ignore the error saying ' Cannot find color scheme'. Just hit Enter\n${NC}"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vi +'PlugInstall' +qa
}

function setup_zsh() {
  h2 "Installing zsh + oh-my-zsh "
  install 'zsh'
  if [ ! -d $ZSH ] ; then
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" --unattended
  fi
  if [ ! -f $HOME/antigen.zsh ] ; then
    curl -L git.io/antigen > $HOME/antigen.zsh
  fi
  add_to_file_unique "source $basedir/zsh/zshrc" ~/.zshrc
  add_to_file_unique "source $basedir/linux/zshrc" ~/.zshrc
  touch ~/.zsh_history # for mcfly
  binstall 'jandedobbeleer/oh-my-posh/oh-my-posh' # https://ohmyposh.dev/
  /bin/zsh -i -c "source ~/antigen.zsh"
}

function setup_tmux() {
  h2 "Setting up tmux......"
  install 'tmux'
  install 'xdg-utils' # needed by tmux-open

  checkout_or_update_git_repo https://github.com/gpakosz/.tmux.git ~/.tmux master
  ln -s -f .tmux/.tmux.conf ~/
  ln -sf $basedir/base/.tmux.conf.local ~/
  add_to_file_unique "source-file ~/.tmux.conf" ~/.tmate.conf
}

function setup_docker() {
  install 'ca-certificates curl gnupg'
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  install "docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
  if ! getent group docker > /dev/null; then
    sudo groupadd docker
  fi
  sudo usermod -aG docker $USER
}

echo "---------------------------------------"
echo "To avoid repeated sudo password prompt"
echo "> sudo visudo"
echo "Add the following line temporarily"
echo "$USER ALL=(ALL) NOPASSWD: ALL"
echo "---------------------------------------"

update_apt
install_homebrew
install_packages
setup_aliases
setup_git
install_node
setup_vim
setup_zsh
setup_tmux
setup_docker
cleanup

h2 "Switching to ZSH "

chsh -s `which zsh`
h2 "Linux Setup complete! "
