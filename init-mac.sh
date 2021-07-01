#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new OSX machine
# 
# Bsed on https://gist.github.com/codeinthehole/26b37efa67041e1307db
#
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# - Twitter (app store)
# - Postgres.app (http://postgresapp.com/)
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install Bash 4
brew install bash

PACKAGES=(
    ffmpeg
    git
    markdown
    npm
    postgresql
    python
    python3
    pypy
    rename
    terminal-notifier
    wget
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
# brew install caskroom/cask/brew-cask

CASKS=(
    dropbox
    firefox
    google-chrome
    google-backup-and-sync
    iterm2
    keepassxc
    keka
    r
    rstudio
    slack
    vagrant
    virtualbox
    visual-studio-code
    vlc
)

echo "Installing cask apps..."
brew install --cask ${CASKS[@]}

#echo "Installing fonts..."
#brew tap homebrew/cask-fonts
#FONTS=(
#    font-inconsolidata
#    font-roboto
#    font-clear-sans
#)
#brew install --cask ${FONTS[@]}

echo "Installing Python packages..."
PYTHON_PACKAGES=(
    ipython
    virtualenv
    virtualenvwrapper
)
sudo pip3 install ${PYTHON_PACKAGES[@]}

echo "Installing global npm packages..."
npm install marked -g

echo "Configuring OSX..."

# Set fast key repeat rate
#defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

#echo "Creating folder structure..."
# [[ ! -d Wiki ]] && mkdir Wiki
# [[ ! -d Workspace ]] && mkdir Workspace

echo "Setting iterm preferences to colorise folders, etc"
echo "alias ls='ls -G'" >> ~/.zshrc

echo "Bootstrapping complete"
