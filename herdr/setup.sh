#!/bin/bash

# Install herdr
sudo dnf install herdr -y

# Ensure herdr config directory exists
mkdir -p ~/.config/herdr

# Copy configuration
cp config.toml ~/.config/herdr/config.toml

echo "Herdr installed and configured successfully!"
