#!/bin/bash
#Skrypt automatyzujacy instalacje brakujacych paczek w OSx 
#oraz tworzący konto uzytkownika z hasłem "Test123!" oraz uprawnieniami admina
if [[ "$1" == '' ]] || [[ "$2" == '' ]]
then
    echo "Podaj jako "'$1'" Imie i Nazwisko, jako "'$2'"  inazwisko w celu utworzenia konta uzytkownika"
    exit 0
fi  

instalacja HomeBrew oraz cask
sudo yes "" |  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
sleep 2
DOCTOR=$(brew doctor)
echo $DOCTOR
echo -e "\e[42m++++++ Instalacja cask ++++++"
sleep 1
brew install cask
sleep 1
narzedzia
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
sudo dscl . -create /Users/$2 UniqueID 551
sudo dscl . -create /Users/$2 PrimaryGroupID 80
sudo dscl . -create /Users/$2 NFSHomeDirectory /Users/$2
sudo dscl . -passwd /Users/$2 Test123!
sudo dscl . -append /Groups/admin GroupMembership $2
sudo scutil --set HostName espeo-$2
sudo scutil --set ComputerName espeo-$2
sudo scutil --set LocalHostName espeo-$2 
sudo fdesetup enable #turns on FileVault 
ioreg -l | grep IOPlatformSerialNumber