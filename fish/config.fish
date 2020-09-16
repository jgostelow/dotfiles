starship init fish | source

eval (hub alias -s)
alias git=hub

status --is-interactive; and source (rbenv init -|psub)

# Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

function reload --on-variable _reload_config
  source ~/.config/fish/config.fish
end

function cdls
  cd $argv;
  ls;
end

# Recursive search and replace

# $1 = file pattern e.g. *.go
# $2 = old string
# $3 new string
# e.g. sandr .go Sirupsen sirupsen
function sandr
  find . -name $argv[1] -print0 | xargs -0 sed -i "" "s/$argv[2]/$argv[3]/g"
end

# Git
# open the files that were modified in a specified commit
function gedit
  vim -O (git show --pretty=format: --name-only $argv | sed '$!N; s/\n/ /;')
end

# Docker
# https://github.com/jesseduffield/lazydocker/blob/master/README.md
function drmii
  docker rmi -f (docker images $argv[1] -q | uniq)
end
function dsh # run a shell from an image
    docker run -ti --entrypoint="" $argv sh
end
function dcsh
    docker-compose exec $argv sh
end

# Kubernetes
function ksh
  kubectl exec -ti $argv sh
end

function nvm
	bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

function gvm
  bass source ~/.gvm/scripts/gvm ';' gvm $argv
end

function yvm
  source /usr/local/opt/yvm/yvm.fish ';' yvm $argv
end

theme_gruvbox dark hard
