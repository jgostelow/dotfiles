CYAN='\033[0;36m'
NC='\033[0m' # No Color
export HOMEBREW_NO_INSTALL_CLEANUP=1

function install {
  printf "${CYAN}############################################################## BREW: Installing $1${NC}\n"
  NONINTERACTIVE=1 brew install --quiet $1
}

function install_homebrew() {
	printf "${CYAN}############################################################## Installing+Updating homebrew${NC}\n"
	[ ! -f "`which brew`" ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update > /dev/null
}

function cleanup() {
  printf "${CYAN}############################################################## Cleaning Up! $1${NC}\n"
}
