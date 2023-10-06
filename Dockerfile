from ubuntu:23.04
LABEL maintainer="Jonathan Gostelow <jonathan.gostelow@gmail.com>"

# USER setup
ARG HOME=/root
WORKDIR ${HOME}

# APT packages
RUN echo "Installing Apt packages" \
	&& apt update && apt install -yq tzdata curl wget zip fontconfig git build-essential libz-dev \
	zsh tmux glances exa fd-find watch tig jq

# LOCALE/TIMEZONE
# SOURCE : https://dev.to/0xbf/set-timezone-in-your-docker-image-d22
RUN echo "Setting Local timezone" \
	&& ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime \
    	&& dpkg-reconfigure -f noninteractive tzdata

# HOMEBREW
# SOURCE : https://linux.how2shout.com/how-to-install-brew-ubuntu-20-04-lts-linux/
ENV HOMEBREW_NO_INSTALL_CLEANUP=1
RUN echo "Installing Homebrew" \
	&& NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
	&& echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> .profile \
	&& eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
RUN echo "Installing Homebrew packages" \
	&& brew update \
	&& brew tap cantino/mcfly \
	&& brew tap jesseduffield/lazygit \
	&& brew install -q neovim yq mcfly lazygit diff-so-fancy
COPY ./base/lazygit.config.yml .config/lazygit/config.yml

# FONTS
RUN echo "Installing Nerd Font" \
	&& wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/JetBrainsMono.zip \
	&& unzip JetBrainsMono.zip -d ~/.fonts \
	&& rm -f JetBrainsMono.zip \
	&& fc-cache -fv

# ZSH
RUN echo "Installing oh-my-zsh + antigen" \
	&& /bin/bash -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
	&& apt update && apt install -y zsh-antigen \
	&& curl -L git.io/antigen > antigen.zsh
## Oh-my-posh (zsh themes)
RUN echo "Installing oh-my-posh (ZSH themes)" \
	&& wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh \
	&& chmod +x /usr/local/bin/oh-my-posh
COPY ./zsh/zshrc .zshrc
COPY ./zsh/functions.zsh .zshfn/functions.zsh
RUN echo "source ~/.zshfn/functions.zsh" >> .zshrc
RUN echo "Installing oh-my-posh themes" \
	&& mkdir .poshthemes \
	&& wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O .poshthemes/themes.zip \
	&& unzip .poshthemes/themes.zip -d .poshthemes \
	&& chmod u+rw .poshthemes/*.json \
	&& rm .poshthemes/themes.zip \
	&& echo 'eval "$(oh-my-posh init zsh --config ~/.poshthemes/sonicboom_light.omp.json)"' >> .zshrc
### create zsh_history for McFly to parse
RUN echo "Switching default shell to ZSH" \
	&& touch /root/.zsh_history \
	&& chsh -s `which zsh`

# TMUX
COPY ./base/.tmux.conf ./
RUN echo "Installing tmux plugins" \
	&& git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm \
	&& ~/.tmux/plugins/tpm/scripts/install_plugins.sh

# VIM
# Source : https://youtu.be/Mtgo-nP_r8Y
RUN echo "Installing NVChad (NeoVim)" \
	&& git clone https://github.com/NvChad/NvChad .config/nvim --depth 1
# TODO - add nvim plugins - e.g. https://github.com/xiyaowong/transparent.nvim

# GIT
COPY ./base/gitconfig ${HOME}/.gitconfig
COPY ./base/gitignore_global .gitignore_global

#### Node ###
RUN brew install node

#### Ruby ###
#binstall 'rbenv'
#binstall 'ruby-build'
#
#printf "${CYAN}############################################################## Installing Ruby 2.7 \n${NC}"
#rbenv install 2.7.4
#rbenv global 2.7.4
#rbenv rehash
#
#ln -sf ./base/.gemrc 
#
#printf "${CYAN}############################################################## Installing Rails 5.2 \n${NC}"
#gem install rails -v 6.1.6

# ALIASES
COPY ./base/aliases .aliases
