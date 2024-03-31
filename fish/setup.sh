#/bin/bash

# install
sudo apt-add-repository ppa:fish-shell/release-3 -y
sudo apt update -y
sudo apt install fish -y

# set as default shell
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish