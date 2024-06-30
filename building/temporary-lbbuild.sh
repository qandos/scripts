#!/bin/bash

# Clean previous build
lb clean

# Configure live-build
lb config --distribution stable --archive-areas "main contrib non-free" --debian-installer live

# Create package lists
mkdir -p config/package-lists

# Add kernel package to package lists
echo "linux-image-amd64" > config/package-lists/kernel.list.chroot

# Add other packages to package lists
echo "kde-plasma-desktop" > config/package-lists/kde.list.chroot
echo "firefox google-chrome-stable microsoft-edge-stable" > config/package-lists/browsers.list.chroot

# Enter the chroot environment to install the kernel
sudo chroot ./chroot <<EOF
apt update
apt install linux-image-amd64
exit
EOF

# Build the ISO
lb build
