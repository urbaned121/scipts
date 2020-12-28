#!/bin/bash
#Skrypt automatyzujacy instalacje brakujacych paczek w OSx 
#oraz tworzący konto uzytkownika z hasłem "Test123!" oraz uprawnieniami admina


if [[ "$1" == '' ]] || [[ "$2" == '' ]];
then
    echo "Podaj jako "'$1'" Imie i Nazwisko, jako "'$2'" inazwisko w celu utworzenia konta uzytkownika"
    exit 0
fi  
RealName=${1}
UserName=${2}
#TOKEN=$(cat ./file.txt)
#installing homebrew & etc.
sudo yes "" |  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sleep 2
brew doctor
echo 
sleep 1
echo -e "Brew cask installation"
slep 1 
brew install cask
sleep 1
#common used tools
brew install wget htop git
brew install --cask google-chrome 
brew install --cask visual-studio-code
brew install --cask slack
brew install --cask skype
brew install --cask docker
#chcecking if user with $Username already exist 
if  [[ $UserName == $(dscl . -list /Users UniqueID | awk '{print $1}' | grep -w $UserName) ]]; 
then
    echo "User already exists!"
    exit 0
fi
#increment UniqeID if we creating more than one new user 
LastID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1)
NextID=$((LastID + 1))
CurrentUser=$USER
echo "Creating user directory, enter admin password:"

sysadminctl -addUser $UserName -fullName $RealName -password Test123! -admin #[-picture <full path to user image>]

# sudo dscl . -create /Users/"$UserName"
# sudo dscl . -create /Users/"$UserName" UserShell /bin/zsh
# sudo dscl . -create /Users/"$UserName" RealName "$RealName"
# sudo dscl . -create /Users/"$UserName" UniqueID $NextID
# sudo dscl . -create /Users/"$UserName" PrimaryGroupID 80
# sudo dscl . -create /Users/"$UserName" NFSHomeDirectory /Users/"$UserName"
# sudo dscl . -passwd /Users/"$UserName" Test123!
# sudo dscl . -append /Groups/admin GroupMembership "$UserName"
sudo scutil --set HostName espeo-"$UserName"
sudo scutil --set ComputerName espeo-"$UserName"
sudo scutil --set LocalHostName espeo-"$UserName" 
# printf "Creating new user directory, enter admin password:\n"
# sudo createhomedir -u "$UserName" -c
ioreg -l | grep IOPlatformSerialNumber
echo "New user $(dscl . -list /Users UniqueID | awk '{print $1}' | grep -w $UserName) has been created with unique ID $(dscl . -list /Users UniqueID | grep -w $UserName | awk '{print $2}')"
echo "Enter admin login and password to activate FileVault"
#enabling FileVault and add $UserName to list of users available to unlock encrypted disk
sudo fdesetup enable -user "$CurrentUser" -usertoadd "$UserName"
#sudo fdesetup enable 
#printf "Enter admin login and password to add recently created user to group avaiable to unlock disk"
#sudo fdesetup add -usertoadd "$UserName"
printf "Users avaiable to unlock disk: %s\n$(sudo fdesetup list)'" | cut -d',' -f1 
printf "Generating SSH key for newly created user"
su "$UserName" -c 'ssh-keygen -t rsa -b 2048 -C "$UserName" '
su "$UserName" -c 'ls -al ~/.ssh'
printf "Finished!\nPlease reboot your computer\n"
#su "$UserName" -c 'curl -F "content=$(cat ~/.ssh/id_rsa.pub)" -F "initial_comment=SHH Pub key for user $(whoami)" -F channels=C9QAHNH7C -F token="$TOKEN" https://slack.com/api/files.upload'
