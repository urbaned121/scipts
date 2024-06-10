#!/bin/bash

# ----------------------------------------------------------
# ---------------Enable application firewall----------------
# ----------------------------------------------------------
echo '--- Enable application firewall'
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true

cd ~ || exit
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ----------------------------------------------------------
# ---------Disable Homebrew user behavior analytics---------
# ----------------------------------------------------------
echo '--- Disable Homebrew user behavior analytics'
command='export HOMEBREW_NO_ANALYTICS=1'
declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
for profile_file in "${profile_files[@]}"
do
    touch "$profile_file"
    if ! grep -q "$command" "${profile_file}"; then
        echo "$command" >> "$profile_file"
        echo "[$profile_file] Configured"
    else
        echo "[$profile_file] No need for any action, already configured"
    fi
done

casktools=(
    iterm2
    vscodium
    alacritty
    fig
    docker
)

brew install --cask "${casktools[@]}"

clitools=(
  bat #A cat clone with syntax highlighting and Git integration.
  dust #du + rust = dust. Like du but more intuitive.
  lsd # rewrite of GNU ls with lots of added features
  fd #fd is a program to find entries in your filesystem
  git
  git-delta
  htop
  jq
  midnight-commander
  procs #procs is a replacement for ps written in Rust.
  sd #sd - search & displace
  tldr
  wget
  z
  google-chrome
  gh
  zsh
  git-flow
  lazygit
  node
  yarn
#   fnm
  pnpm
)
brew install "${clitools[@]}"


# # other tools
# brew install --cask alt-tab
# brew install --cask raycast
# brew install --cask shottr


git config --global user.name "Dawid U"
git config --global user.email "dawurb@gmail.com"
# git config --global push.default current
# git config --global core.pager delta
# git config --global core.pager "delta --dark"
# git config --global core.pager "delta --line-numbers --dark"

# zsh
# brew install antigen

# echo "eval '$(fnm env)'" >> .zshrc

# python
# sudo easy_install pip
# pip install --user powerline-status
# pip install ipython
# brew install python3

# python tools
# pip3 install ipython
# pip3 install jedi
# pip3 install rope
# pip3 install flake8
# pip3 install autopep8
# pip3 install yapf
# pip3 install black

# stuff
# mkdir code
# mkdir code/open-source
# mkdir stuff
# git clone https://github.com/denilsonsa/prettyping $HOME/stuff
# git clone https://github.com/przemyslawjanpietrzak/dotfiles $HOME/code/open-source
# curl -L git.io/antigen > $HOME/stuff/antigen.zsh

# # load configs
# cp $HOME/code/open-source/alacritty.toml $HOME/.config/alacritty/
# cp $HOME/code/open-source/tmux.conf $HOME/.config/tmux/
# cp $HOME/code/open-source/.zshrc $HOME/


# ssh
# brew install tunnelblick
# brew install openssh

# media
# brew install vlc
# brew install transmission
# brew install spotify

# aws
# pip3 install awscli --upgrade --user

# Dodanie ustawień do .zshrc
zshrc_file="$HOME/.zshrc"
{
  echo 'HISTFILE="$HOME/.zsh_history"'
  echo 'HISTSIZE=10000000'
  echo 'SAVEHIST=10000000'
  echo 'HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"'
} >> "$zshrc_file"

source "$zshrc_file"