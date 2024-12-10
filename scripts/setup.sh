#! /bin/bash

bash $(pwd)/iparu.sh
paru -S $(cut -d' ' -f1 <./conf/package.conf) --needed
sudo npm install -g neovim
stow .
ln -s ~/config/nvchad/ ~/config/.config/nvim/lua/custom

# rm -rf ~/.local/share/
# git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

bash $(pwd)/sysd.sh

git config --global user.email "itsrobel.schwarz@gmail.com"
git config --global user.name "Robel Schwarz"
git config --global credential.helper store
chsh -s $(which fish)

# Neovim things

## For laptops you need to copy the login.conf file to /etc/systemd/
#then run systemctl restart systemd-logind
if laptop-detect; then
	sudo rm /etc/systemd/logind.conf
	sudo cp $(pwd)/conf/logind.conf /etc/systemd/
else
	echo "not a laptop"
fi

sudo rm /etc/paru.conf
sudo rm /etc/pacman.conf
sudo cp conf/paru.conf /etc/
sudo cp conf/pacman.conf /etc/
