CYAN='\033[0;36m'
NC='\033[0m' # No Color
export HOMEBREW_NO_INSTALL_CLEANUP=1

function binstall {
  printf "${CYAN}-------------------------------------------------------------- BREW: Installing $1${NC}\n"
  NONINTERACTIVE=1 brew install --quiet $1
}

function install {
  printf "${CYAN}-------------------------------------------------------------- APT : Installing $1${NC}\n"
  sudo apt-get -qq install $1 -y > /dev/null
}


function cleanup() {
  sudo apt-get autoremove -y
}
