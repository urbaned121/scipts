#!/bin/bash
#Skrypt automatyzujacy instalacje brakujacych paczek w OSx 
#oraz tworzący konto uzytkownika z hasłem "Test123!" oraz uprawnieniami admina
if [[ "$1" == '' ]] || [[ "$2" == '' ]]
then
    echo "Podaj jako "'$1'" Imie i Nazwisko, jako "'$2'"  inazwisko w celu utworzenia konta uzytkownika"
    exit 0
fi  

#instalacja HomeBrew oraz cask
sudo yes "" |  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
sleep 2
DOCTOR=$(brew doctor)
echo $DOCTOR
echo -e "\e[42m++++++ Instalacja cask ++++++"
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

sudo dscl . -create /Users/$2
sudo dscl . -create /Users/$2 UserShell /bin/bash
sudo dscl . -create /Users/$2 RealName "$1"
sudo dscl . -create /Users/$2 UniqueID 1001
sudo dscl . -create /Users/$2 PrimaryGroupID 1000
sudo dscl . -create /Users/$2 NFSHomeDirectory /Local/Users/$2
sudo dscl . -passwd /Users/$2 Test123!
sudo dscl . -append /Groups/admin GroupMembership $2
sudo wget https://assets.espeo.eu/201811-logos/espeologo.png -P Library/User\ Pictures/
#sudo dscl . -create /Local/Users/$2 Picture "/Library/User Pictures/espeologo.png"
