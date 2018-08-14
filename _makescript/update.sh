#!/usr/bin/env bash
set -e

if [ -z "$SUDO_USER" ]; then
CUSER=$USER
else
CUSER=$SUDO_USER
fi

which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    #brew update
    true
fi


### cask
#brew tap caskroom/cask
#brew tap caskroom/versions
#brew install brew-cask
##python packages
#
### brew packages
#brew install https://github.com/Homebrew/homebrew-core/blob/master/Formula/wget.rb
#
##brew install https://raw.githubusercontent.com/Homebrew/homebrew/5e589c8e5de81de117f8a77f5b72fff49488fb02/Library/Formula/ansible.rb
#brew install https://github.com/Homebrew/homebrew-core/blob/master/Formula/ansible.rb
#brew install https://github.com/Homebrew/homebrew-core/blob/master/Formula/docker.rb
#brew install https://github.com/Homebrew/homebrew-core/blob/master/Formula/docker-compose.rb
#brew install https://github.com/Homebrew/homebrew-core/blob/master/Formula/docker-machine.rb
#brew install https://github.com/Homebrew/homebrew-core/blob/master/Formula/docker-swarm.rb
#brew install https://github.com/Homebrew/homebrew-core/blob/master/Formula/mongodb.rb
#brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/git.rb
#
#brew cleanup
#
#brew cask install sublime-text3
#brew cask install qlcolorcode
#brew cask install qlstephen
#brew cask install qlmarkdown
#brew cask install quicklook-json
#brew cask install qlprettypatch
#brew cask install quicklook-csv
#brew cask install betterzipql
#brew cask install webpquicklook
#brew cask install suspicious-package
#
#brew cask install alfred
#brew cask install android-file-transfer
#brew cask install asepsis
#brew cask install cheatsheet
#brew cask install spectacle
