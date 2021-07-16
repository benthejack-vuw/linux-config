#!/bin/bash

sudo apt install sed
sudo sed -i 's/^\(deb .*\)main$/\1main contrib non-free/' /etc/apt/sources.list
sudo apt update

sudo apt install -y linux-headers-$(uname -r) curl wget software-properties-common apt-transport-https gnupg git feh fonts-powerline i3lock scrot alsa-utils pulseaudio nautilus terminator build-essential xinit xorg libx11-dev libxft-dev libxinerama-dev nvidia-driver pavucontrol 

sudo curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

pushd ./dwm/
if test -f "./config.h"; then
sudo rm config.h
fi
sudo make clean install
popd

pushd ./st/
if test -f "./config.h"; then
sudo rm config.h
fi
sudo make clean install
popd

sudo curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
npm config set ignore-scripts true
npm config set prefix ~/.npm

sudo curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

sudo echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee -a /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-keyring brave-browser

curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update && sudo apt install -y spotify-client

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sudo cp -r ./fonts /usr/share/
cp ./config/scripts/.xinitrc ~/
cp ./config/scripts/.Xresources ~/
sudo cp ./config/scripts/asound.conf /etc/ 
sudo cp -r ./Pictures ~/
sudo cp ./programs/sp /usr/bin/
sudo chmod +x /usr/bin/sp
sudo cp ./config/agnoster-bookmark.zsh-theme ~/.oh-my-zsh/custom/themes
sed -i 's/robbyrussell/agnoster-bookmark/' ~/.zshrc

git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git solarized
pushd ./solarized
./install.sh -s dark --install-dircolors
popd
echo "eval \`dircolors ~/.dir_colors/dircolors\`" >> ~/.zshrc
cat ./config/scripts/autostartx >> ~/.zshrc

chsh -s /bin/zsh

curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt install nodejs
