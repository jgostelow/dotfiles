from ubuntu:23.04
LABEL maintainer="Jonathan Gostelow <jonathan.gostelow@gmail.com>"

ARG basedir=$HOME/dotfiles
ENV HOMEBREW_NO_INSTALL_CLEANUP=1

# LOCALE/TIMEZONE
# SOURCE : https://dev.to/0xbf/set-timezone-in-your-docker-image-d22
RUN apt update && apt install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# HOMEBREW
# SOURCE : https://linux.how2shout.com/how-to-install-brew-ubuntu-20-04-lts-linux/
RUN apt update && apt install -y curl git build-essential libz-dev
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
	&& echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile \
	&& eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# GENERAL
RUN apt update && apt install -y zsh tmux neovim wget glances exa fd-find watch tig jq exuberant-ctags nodejs
RUN brew update && brew install -q yq

#brew tap jesseduffield/lazydocker
#binstall 'lazydocker'
#brew tap jesseduffield/lazygit
#binstall 'lazygit'
#ln -sf $basedir/base/lazygit.config.yml ~/.config/lazygit/config.yml
#

# GIT
ADD $basedir/base/gitconfig ~/.gitconfig
ADD $basedir/base/gitignore_global ~/.gitignore_global
RUN brew update && brew install diff-so-fancy

# VIM
#ln -sf $basedir/base/.vim/* ~/.vim/
#mkdir ~/.vim/swapfiles
#curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#vi +'PlugInstall' +qa

# TMUX
ADD $basedir/base/.tmux.conf ~/
#echo "source-file ~/.tmux.conf" > ~/.tmate.conf

# ZSH
RUN /bin/bash -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
	&& apt update && apt install -y zsh-antigen \
	&& brew install jandedobbeleer/oh-my-posh/oh-my-posh 
ADD $basedir/zsh/zshrc > ~/.zshrc
RUN mkdir ~/.zshfn
ADD $baserdir/zsh/functions.zsh ~/.zshfn/functions.zsh
RUN echo "~/.zshfn/functions.zsh" >> ~/.zshrc

# ALIASES
ADD $basedir/base/aliases ~/.aliases

#### Ruby ###
#binstall 'rbenv'
#binstall 'ruby-build'
#
#printf "${CYAN}############################################################## Installing Ruby 2.7 \n${NC}"
#rbenv install 2.7.4
#rbenv global 2.7.4
#rbenv rehash
#
#ln -sf $basedir/base/.gemrc ~/
#
#printf "${CYAN}############################################################## Installing Rails 5.2 \n${NC}"
#gem install rails -v 6.1.6
#
#printf "${CYAN}############################################################## Linux Setup complete! \n${NC}"
#printf "${CYAN}############################################################## Switching to ZSH \n${NC}"
#chsh -s `which zsh`
