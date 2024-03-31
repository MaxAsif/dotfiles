#/bin/bash

# install
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish

# set as default shell
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish