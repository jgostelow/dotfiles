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
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
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
  ln -sf $basedir/base/gitignore_global ~/.gitignore_global
}

function install_node() {
  printf "${CYAN}############################################################## Installing v21.x Nodejs......\n${NC}"
  install 'ca-certificates'
  install 'curl'
  install 'gnupg'
  sudo mkdir -p /etc/apt/keyrings
  NODE_MAJOR=21
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
  sudo apt-get update
  install 'nodejs' # required by coc.vim

}

function setup_vim() {
  printf "${CYAN}############################################################## Setting up vim......\n${NC}"
  install 'vim'
  ln -sf $basedir/base/.vim ~/
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "${CYAN}Ignore the error saying ' Cannot find color scheme'. Just hit Enter${NC}"
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
  echo "source $basedir/zsh/zshrc" >> ~/.zshrc
  echo "alias clip=clip.exe" >> ~/.zshrc # like pbcopy on windows
  touch ~/.zsh_history # for mcfly
  echo "source /home/raziel/dotfiles/zsh/functions.zsh" >> ~/.zshrc # replace with `realpath functions.zsh`
  echo "eval \"$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> ~/.zshrc # replace hardcoded path
  binstall 'jandedobbeleer/oh-my-posh/oh-my-posh' # https://ohmyposh.dev/
  /bin/zsh -i -c "source ~/antigen.zsh"
}

function setup_tmux() {
  printf "${CYAN}############################################################## Setting up tmux......\n${NC}"
  install 'tmux'
  install 'xdg-utils' # needed by tmux-open
  ln -sf $basedir/base/.tmux.conf ~/
  echo "source-file ~/.tmux.conf" > ~/.tmate.conf
  if [ ! -d ~/.tmux/plugins/tpm ] ; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins
  fi
  tmux source ~/.tmux.conf
}
printf "${CYAN}############################################################## Installing Homebrew/Apt packages${NC}\n"

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

printf "${CYAN}############################################################## Linux Setup complete! \n${NC}"
printf "${CYAN}############################################################## Switching to ZSH \n${NC}"

chsh -s `which zsh`
