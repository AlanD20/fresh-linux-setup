#!/bin/zsh

echo "========================================================"
echo "    Running User Setup"
echo "========================================================"


if [ -z "$1" ]
then
    echo "Existing user is  required."
    echo "- First argument is User."
    exit 0;
fi

usr=$1

echo "=========================================="
echo 'Setting up git...'
echo "=========================================="

git config --global init.defaultBranch main
git config --global user.email "aland20@pm.me"
git config --global user.name "AlanD20"

echo "=========================================="
echo 'git setup succeded'
echo "=========================================="


echo "=========================================="
echo "Installing oh-my-zsh..."
echo "=========================================="

yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cd /home/$usr && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

sudo cat /home/fresh-linux-setup/files/zshrc > /home/$usr/.zshrc

echo "=========================================="
echo "oh-my-zsh Customization completed!"
echo "=========================================="


echo "=========================================="
echo 'Installing Nodejs/nvm!'
echo "=========================================="


curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

. ~/.zshrc
. .nvm/nvm.sh

nvm install 16.15.1
nvm alias default 16.15.1
nvm use default
npm install yarn --location=global
npm install npm@latest --location=global

echo "=========================================="
echo 'nvm installed with global dependencies!'
echo "=========================================="
