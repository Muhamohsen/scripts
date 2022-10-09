#! /bin/sh
#This script is intented to run th efirst thing after installing a linux VPS to setup some security meausres
#check if the script is run as sudo 
if [[ $EUID -ne 0 ]]; then
	echo "Please run this script as root" 1>&2
	exit 1
fi


#enable automatic security updates
sudo dpkg-reconfigure --priority=low unattended-upgrades


#Create a new user
read -p "Enter your user name: " -r user_name
adduser $user_name
usermod -aG sudo $user_name

su - $user_name
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys

#under development 
read -e -p "Enter public ssh key, use tab for completion: " ssh_pub_file
pbcopy < $ssh_pub_file
pbpaste > ~/.ssh/authorized_keys

#Disable root login 
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
#Disable password login 
#sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
systemctl reload sshd
