#!/bin/bash
# Created By TheDreWen
# Github : 


# Variables :

username="debian"
password="changeme"
publickey="public ssh key"

# Script :

echo "WARNING ! Please configure variables in file !"

read  -n 1 -p "Confirmation that you have changed the variables : " mainmenuinput

echo "Install Updates and Utils..."
sudo apt update && apt upgrade -y
sudo apt install btop neofetch

echo "Install Docker"
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "User creation (sudo)..."
# Create the user with the specified username
sudo useradd -m -s /bin/bash $username
sudo usermod -aG docker debian
sudo usermod -aG sudo debian

# Set the user's password
echo "$username:$password" | sudo chpasswd
sudo mkdir /home/$username/.ssh
sudo chown -R $username:$username /home/$username/.ssh
echo "$publickey" > /home/$username/.ssh/authorized_keys

echo "Enable SSH KEYS AND Disable Password..."
sudo sed -i -e 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo systemctl restart sshd