#!/bin/bash

# Clean previous build
lb clean

# Configure live-build
lb config --distribution stable --archive-areas "main contrib non-free" --debian-installer live

# Create package lists
mkdir -p config/package-lists

# Kernel
echo "linux-image-amd64" > config/package-lists/kernel.list.chroot

# Desktop Environment
echo "kde-plasma-desktop" > config/package-lists/kde.list.chroot

# Web Browsers
echo "firefox" > config/package-lists/browsers.list.chroot
echo "google-chrome-stable" >> config/package-lists/browsers.list.chroot
echo "microsoft-edge-stable" >> config/package-lists/browsers.list.chroot

# Video Editing Software
echo "davinci-resolve" > config/package-lists/video-editing.list.chroot
echo "shotcut" >> config/package-lists/video-editing.list.chroot
echo "kdenlive" >> config/package-lists/video-editing.list.chroot

# Gaming
echo "steam" > config/package-lists/gaming.list.chroot
echo "lutris" >> config/package-lists/gaming.list.chroot

# Ensure repositories are correctly set up
mkdir -p config/archives
cat <<EOT > config/archives/your-repo.binary
deb http://deb.debian.org/debian stable main contrib non-free
deb http://deb.debian.org/debian stable-updates main contrib non-free
deb http://security.debian.org/debian-security stable-security main contrib non-free
EOT

# Add external repositories for specific packages
mkdir -p config/hooks
cat <<EOT > config/hooks/00-add-repositories.chroot
#!/bin/bash
set -e

# Add Google Chrome repository
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Add Microsoft Edge repository
wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list

# Update package list
apt-get update
EOT

chmod +x config/hooks/00-add-repositories.chroot

# Build the ISO
lb build
