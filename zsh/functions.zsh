function reload() {
  source ~/.zshrc
}

function cdls() {
  cd $argv;
  ls;
}

# Recursive search and replace

# $1 = file pattern e.g. *.go
# $2 = old string
# $3 new string
# e.g. sandr .go Sirupsen sirupsen
function sandr() {
  find . -name $1 -print0 | xargs -0 sed -i "" "s/$2/$3/g"
}

# Git
# open the files that were modified in a specified commit
function gedit() {
  vim -O (git show --pretty=format: --name-only $1 | sed '$!N; s/\n/ /;')
}

# Docker
# https://github.com/jesseduffield/lazydocker/blob/master/README.md
function drmii() {
  docker rmi -f (docker images $1 -q | uniq)
}
function dsh() { # run a shell from an image
    docker run -ti --entrypoint="" $1 sh
  }
function dcsh() {
    docker-compose exec $1 sh
  }

# Kubernetes
function ksh() {
  kubectl exec -ti $1 sh
}

# Ruby
if which rbenv > /dev/null; then eval "(rbenv init -)"; fi
