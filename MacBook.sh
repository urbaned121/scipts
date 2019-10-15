#!/bin/bash
#Skrypt automatyzujacy instalacje brakujacych paczek w OSx 
#oraz tworzący konto uzytkownika z hasłem "Test123!" oraz uprawnieniami admina
if [[ "$1" == '' ]] || [[ "$2" == '' ]];
then
    echo "Podaj jako "'$1'" Imie i Nazwisko, jako "'$2'"  inazwisko w celu utworzenia konta uzytkownika"
    exit 0
fi  

#instalacja HomeBrew oraz cask
sudo yes "" |  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
sleep 2
DOCTOR=$(brew doctor)
echo $DOCTOR
sleep 1
echo -e "++++++ Instalacja cask ++++++"
brew install cask
sleep 1
#narzedzia
brew install wget htop git
brew cask install google-chrome 
brew cask install visual-studio-code
brew cask install slack
brew cask install skype

if [[ $2 == "dscl . -list /Users UniqueID | awk '{print $1}' | grep -w $2" ]]; 
then
    echo "User already exists!"
    exit 0
fi

LastID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1)
NextID=$((LastID + 1))

sudo dscl . -create /Users/"$2"
sudo dscl . -create /Users/"$2" UserShell /bin/bash
sudo dscl . -create /Users/"$2" RealName "$1"
sudo dscl . -create /Users/"$2" UniqueID $NextID
sudo dscl . -create /Users/"$2" PrimaryGroupID 20
sudo dscl . -create /Users/"$2" NFSHomeDirectory /Users/"$2"
sudo dscl . -passwd /Users/"$2" Test123!
sudo dscl . -append /Groups/admin GroupMembership "$2"
sudo scutil --set HostName espeo-"$2"
sudo scutil --set ComputerName espeo-"$2"
sudo scutil --set LocalHostName espeo-"$2" 
sudo createhomedir -u "$2" -c
sudo fdesetup enable #turns on FileVault
ioreg -l | grep IOPlatformSerialNumber