#!/bin/bash

# install tmux
sudo apt-get install tmux -y

# install tmux plugin manager tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# copu tmux.conf
cp tmux.conf ~/.tmux.conf
