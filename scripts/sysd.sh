#! /bin/bash

sudo systemctl enable auto-cpufreq
sudo systemctl enable bluetooth
sudo systemctl enable bluetooth-autoconnect
sudo systemctl enable sshd
# sudo systemctl enable libvirtd
# sudo systemctl enable NetworkManager

# sudo systemctl enable docker
# sudo systemctl enable firewalld

# add user to video group enabling xbacklight
sudo gpasswd -a $(whoami) video
