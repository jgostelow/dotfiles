from ubuntu:23.04
LABEL maintainer="Jonathan Gostelow <jonathan.gostelow@gmail.com>"

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
RUN apt update && apt install -y zsh tmux neovim zip wget glances exa fd-find watch tig jq exuberant-ctags nodejs
RUN brew update \
	&& brew tap cantino/mcfly \
	&& brew install -q yq mcfly

#brew tap jesseduffield/lazydocker
#binstall 'lazydocker'
#brew tap jesseduffield/lazygit
#binstall 'lazygit'
#ln -sf ./base/lazygit.config.yml ~/.config/lazygit/config.yml
#

# GIT
COPY ./base/gitconfig /root/.gitconfig
COPY ./base/gitignore_global /root/.gitignore_global
RUN brew update && brew install diff-so-fancy

# VIM
#ln -sf ./base/.vim/* /root/.vim/
#mkdir /root/.vim/swapfiles
#curl -fLo /root/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#vi +'PlugInstall' +qa

# TMUX
COPY ./base/.tmux.conf /root/
#echo "source-file /root/.tmux.conf" > /root/.tmate.conf

# ZSH
RUN /bin/bash -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
	&& apt update && apt install -y zsh-antigen \
	&& curl -L git.io/antigen > ~/antigen.zsh
RUN wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh \
	&& chmod +x /usr/local/bin/oh-my-posh
RUN mkdir ~/.poshthemes \
	&& wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip \
	&& unzip ~/.poshthemes/themes.zip -d ~/.poshthemes \
	&& chmod u+rw ~/.poshthemes/*.json \
	&& rm ~/.poshthemes/themes.zip
COPY ./zsh/zshrc /root/.zshrc
RUN mkdir /root/.zshfn
COPY ./zsh/functions.zsh /root/.zshfn/functions.zsh
RUN echo "source /root/.zshfn/functions.zsh" >> /root/.zshrc \
	&& chsh -s `which zsh`

# ALIASES
COPY ./base/aliases /root/.aliases

#### Ruby ###
#binstall 'rbenv'
#binstall 'ruby-build'
#
#printf "${CYAN}############################################################## Installing Ruby 2.7 \n${NC}"
#rbenv install 2.7.4
#rbenv global 2.7.4
#rbenv rehash
#
#ln -sf ./base/.gemrc ~/
#
#printf "${CYAN}############################################################## Installing Rails 5.2 \n${NC}"
#gem install rails -v 6.1.6
#
#printf "${CYAN}############################################################## Linux Setup complete! \n${NC}"
#printf "${CYAN}############################################################## Switching to ZSH \n${NC}"
#chsh -s `which zsh`
