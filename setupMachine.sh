#!/bin/bash

apt-get install curl wget git zsh  
curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

sudo apt-get install curl software-properties-common
curl -sL https://deb.nodesource.com/setup_13.x | sudo bash -

npm config set ignore-scripts true
npm config set prefix ~/.npm
npm install -g base16-builder
mkdir -p .config/terminator
base16-builder -s solarized -t terminator -b dark > .config/terminator/config

cat dconf-settings.ini | dconf load /
