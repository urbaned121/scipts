#!/bin/bash
#Skrypt automatyzujacy instalacje brakujacych paczek w OSx 
#oraz tworzący konto uzytkownika z hasłem "Test123!" oraz uprawnieniami admina
RealName=${1}
UserName=${2}
#LastID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1)
#NextID=$((LastID + 1))
CurrentUser=$USER


if [[ "$1" == '' ]] || [[ "$2" == '' ]];
then
    echo "Podaj jako "'$1'" Imie i Nazwisko, jako "'$2'" inazwisko w celu utworzenia konta uzytkownika"
    exit 0
fi  

#chcecking if user with $Username already exist 
if  [[ $UserName == $(dscl . -list /Users UniqueID | awk '{print $1}' | grep -w $UserName) ]]; 
    then
    echo "User already exists!"
    exit 0
fi

PS3='Please enter your choice: '
options=("Delivery" "NonDelivery" "Quit")
select opt in "${options[@]}"
do
case $opt in

"Delivery")

#TOKEN=$(cat ./file.txt)
#installing homebrew & etc.
    sudo yes "" |  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    sleep 1
    echo -e "Brew cask installation"
    sleep 1 
    brew install cask
    sleep 1
    brew install wget htop git
    brew install --cask google-chrome 
    brew install --cask visual-studio-code
    brew install --cask slack
    brew install --cask skype
    brew install --cask docker

#increment UniqeID if we creating more than one new user 

    echo "Creating new user with User Name: $UserName , enter admin password:"
    sudo sysadminctl -addUser "$UserName" -fullName "$RealName" -password Test123! -admin #[-picture <full path to user image>]
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
    echo "MacBook serial number is: "
    ioreg -l | grep IOPlatformSerialNumber
    echo "New user $(dscl . -list /Users UniqueID | awk '{print $1}' | grep -w $UserName) has been created with unique ID $(dscl . -list /Users UniqueID | grep -w $UserName | awk '{print $2}')"
    echo "Enter admin login and password to activate FileVault"

#Fix brew to use by multiple users
    printf "Fixing brew permissions, making it able to work for multiple users/n"
    sudo chgrp -R admin $(brew --prefix)/* #admin is a group name common for all users
    sudo chmod -R g+w $(brew --prefix)/*

#enabling disk encryption or add new users to make 
    if sudo fdesetup isactive; 
    then
        sudo fdesetup add -user "$CurrentUser" -usertoadd "$UserName" #if Filevalut is already active add newly created user to group avaiable to unlock disk
        exit 0
    else
        sudo fdesetup enable -user "$CurrentUser" -usertoadd "$UserName" #if Filevault is not active, activate it and add user to group avaialbe to unlock disk 
        exit 0 
    fi
#sudo fdesetup enable 
#printf "Enter admin login and password to add recently created user to group avaiable to unlock disk"
#sudo fdesetup add -usertoadd "$UserName"
    printf "Users avaiable to unlock disk: %s\n$(sudo fdesetup list)'" | cut -d',' -f1 
    printf "Generating SSH key pair for newly created user\n"
    su "$UserName" -c 'ssh-keygen -t rsa -b 2048 -C "$UserName"'
    printf "Enter Admin password to verify rsa files permissions/n"
    su "$UserName" -c 'ls -al ~/.ssh'
    printf "Finished!\nPlease reboot your computer\n"
#su "$UserName" -c 'curl -F "content=$(cat ~/.ssh/id_rsa.pub)" -F "initial_comment=SHH Pub key for user $(whoami)" -F channels=C9QAHNH7C -F token="$TOKEN" https://slack.com/api/files.upload'
         break
        ;;
"NonDelivery")
    sudo yes "" |  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"   
    sleep 1
    echo -e "Brew cask installation"
    sleep 1 
    brew install cask
    sleep 1
    brew install wget htop git
    brew install --cask google-chrome 
    brew install --cask slack
    brew install --cask skype

    echo "Creating user directory, enter admin password:"

    sudo sysadminctl -addUser "$UserName" -fullName "$RealName" -password Test123! -admin #[-picture <full path to user image>]
    sudo scutil --set HostName espeo-"$UserName"
    sudo scutil --set ComputerName espeo-"$UserName"
    sudo scutil --set LocalHostName espeo-"$UserName" 
# printf "Creating new user directory, enter admin password:\n"
# sudo createhomedir -u "$UserName" -c
    echo "MacBook serial number is: " ioreg -l | grep IOPlatformSerialNumber
    echo "New user $(dscl . -list /Users UniqueID | awk '{print $1}' | grep -w $UserName) has been created with unique ID $(dscl . -list /Users UniqueID | grep -w $UserName | awk '{print $2}')"
    echo "Enter admin login and password to activate FileVault"
#enabling FileVault and add $UserName to list of users available to unlock encrypted disk 
#sudo fdesetup enable -user "$CurrentUser" -usertoadd "$UserName"

#Fix brew to use by multiple users
    printf "Fixing brew installation, making it able to work for multiple users/n"
    sudo chgrp -R admin $(brew --prefix)/* #admin is a group name common for all users
    sudo chmod -R g+w $(brew --prefix)/*

#enabling disk encryption or add new users to make 
    if sudo fdesetup isactive; 
    then
        sudo fdesetup add -user "$CurrentUser" -usertoadd "$UserName" #if Filevalut is already active add newly created user to group avaiable to unlock disk
        exit 0
    else
        sudo fdesetup enable -user "$CurrentUser" -usertoadd "$UserName" #if Filevault is not active, activate it and add user to group avaialbe to unlock disk 
        exit 0 
   fi
#sudo fdesetup enable 
#printf "Enter admin login and password to add recently created user to group avaiable to unlock disk"
#sudo fdesetup add -usertoadd "$UserName"
printf "Users avaiable to unlock disk: %s\n$(sudo fdesetup list)'" | cut -d',' -f1 

        break
        ;;

"Quit")
        break
        ;;
*) echo "invalid option $REPLY";;
    esac
done       



