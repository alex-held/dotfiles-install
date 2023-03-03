#!/usr/bin/env zsh

log::step() {
    test -e "$1" || echo -e "✨\e[1;36m $1\e[0m"
}

log::success() {
    test -e "$1" || echo -e "✅\e[1;32m $1\e[0m"
}

command::exists() {
    command -v "$1" 2> /dev/null
}

# Bootstrap Variables
DOTFILES_INSTALL_DIRECTORY="${DOTFILES_INSTALL_DIRECTORY:-$HOME/.dotfiles}"
DOTFILES_CLONE_REPO=${DOTFILES_CLONE_REPO:-'git@github.com:alex-held/.dotfiles.git'}

# Install Brew 
case "${OSTYPE:?}" in
  linux*)
    log::step "installing brew (linux)"
    if [[ -x $(command::exists "brew") ]]; then
        log::success "brew aleady installed"
    else
        sudo apt update
        sudo apt-get install build-essential
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    ;;
  darwin*)
    log::step "installing brew (osx)"
    if [[ -x $(command::exists "brew") ]]; then
        log::success "brew aleady installed"
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bashrc
    fi
   ;;
esac


# Install YADM
print::step "installing yadm"
if [[ -x $(command::exists "yadm") ]]; then
    log::success "yadm aleady installed"
else
    brew install yadm
fi

# Bootstrap dotfiles
yadm clone --bootstrap "${DOTFILES_CLONE_REPO}"