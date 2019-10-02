#!/bin/bash

#Skrypt automatyzujacy instalacje brakujacych paczek w OSx

#instalacja HomeBrew oraz cask
sudo yes "" |  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
sleep 3
DOCTOR=$(brew doctor)
echo $DOCTOR
echo "++++++ Instalacja cask ++++++"
sleep 1
brew install cask
sleep 1
#narzedzia
brew install wget
brew install htop
brew cask install google-chrome
brew cask install visual-studio-code
brew cask install slack
brew install git
brew cask install skype
