#!/bin/bash

sudo apt install sed
sudo sed -i 's/^\(deb .*\)main$/\1main contrib non-free/' /etc/apt/sources.list
sudo apt update
echo "INSTALLING X11 and DEPS"
suo apt install -y linux-headers-$(uname -r) curl wget software-properties-common apt-transport-https gnupg git feh fonts-powerline i3lock scrot alsa-utils pulseaudio nautilus terminator build-essential xinit xorg libx11-dev libxft-dev libxinerama-dev nvidia-driver pavucontrol 

echo "BUILDING AND INSTALLING DWM AND ST"
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


echo "BRAVE"
sudo curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
sudo echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee -a /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-keyring brave-browser

echo "INSTALL ZSH"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "FONTS AND PICS ETC"
sudo cp -r ./fonts /usr/share/
cp ./config/scripts/.xinitrc ~/
cp ./config/scripts/.Xresources ~/
sudo cp ./config/scripts/asound.conf /etc/ 
sudo cp -r ./Pictures ~/
sudo cp ./programs/sp /usr/bin/
sudo chmod +x /usr/bin/sp

echo "ZSH THEME"
sudo cp ./config/agnoster-bookmark.zsh-theme ~/.oh-my-zsh/custom/themes
sed -i 's/robbyrussell/agnoster-bookmark/' ~/.zshrc

echo "TERMINAL COLOURS"
git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git solarized
pushd ./solarized
./install.sh -s dark --install-dircolors
popd
echo "eval \`dircolors ~/.dir_colors/dircolors\`" >> ~/.zshrc
cat ./config/scripts/autostartx >> ~/.zshrc

echo "CHANGE SHELL"
chsh -s /bin/zsh
