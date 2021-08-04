#!/bin/bash

# DEPLOY NKN-COMMERCIAL NEW NODE v1.20
# Thanks to no112358/ALLinONE-nknnode. This script is modified from no112358/ALLinONE-nknnode.
# Copy the whole script and paste in your VPS providers's script option.
# For Vultr, please name the startup script file with extension .sh

#################
### Attention ###
#################

# Please make sure you install your server with ssh key.
# Password login is prohited after installation.

########################
### SCRIPT VARIABLES ###
########################

username="nkn"
benaddress="NKNT61LvBsBSKnZYtM7MY9uV6TYfg9eSX8RW"

# Please change default sshport 22 to your own port number. DDOS attack may consume your monthly bandwidth usage.
sshport="22"

# Insert your ChainDB host url to $websource if available. For detail of how to make your own ChainDB host server, please refer to https://github.com/no112358/ALLinONE-nknnode
# If no url provided, nkn-commercial installation will be synced from height 0 (will take few days)
websource="https://nkn.org/ChainDB_pruned_latest.tar.gz"

######################################################
### UPDATE, ADD USER, DISABLE ROOT PWLOGIN  ###
######################################################

# Start point
apt-get update -y
apt-get upgrade -y

apt-get install unzip ufw nano -y

# Add sudo user and grant privileges
useradd -m -s /sbin/nologin "$username"
#usermod -a -G sudo $username

# Disable root login with password
sed --in-place "s/#Port 22.*/Port "$sshport"/g" /etc/ssh/sshd_config
sed --in-place 's/#AddressFamily any*/AddressFamily inet/g' /etc/ssh/sshd_config
sed --in-place 's/#PermitRootLogin.*/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sed --in-place 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sed --in-place 's/#PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed --in-place 's/^PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart sshd

##############################
### INSTALL NKN-COMMERCIAL ###
##############################

# disable firewall for the installation
ufw --force disable

# Install NKN node miner software
cd /home/$username
wget --quiet --continue https://commercial.nkn.org/downloads/nkn-commercial/linux-amd64.zip
unzip linux-amd64.zip
rm -f linux-amd64.zip
mv linux-amd64 nkn-commercial

chown -R $username:$username /home/$username
chmod -R 755 /home/$username

cd /home/$username/nkn-commercial
cat > config.json <<EOF
{
  "beneficiaryAddr": "$benaddress"
}
EOF

/home/$username/nkn-commercial/nkn-commercial -b $benaddress -d /home/$username/nkn-commercial/ -u $username install

# Wait for DIR and wallet creation
DIR="/home/$username/nkn-commercial/services/nkn-node/"
timestart=$(date +%s)
while [[ $(($(date +%s) - $timestart)) -lt 300 ]]; do # 300sec 5 min
        if [ ! -d "$DIR"ChainDB ] && [ ! -f "$DIR"wallet.json ]; then
	        # if folder and file don't exist wait and repeat check
                sleep 5
        else
                # when file is detected
		sleep 5
		systemctl stop nkn-commercial.service
                sleep 5
		cd "$DIR"
		rm -rf ChainDB/
		# internet download
		wget -O - "$websource" -q --show-progress | tar -xzf -
		chown -R $username:$username /home/$username
        fi
done

##############################
### FIREWALL CONFIGURATION ###
##############################

# Configure Firewall and ports
ufw allow 30001
ufw allow 30002
ufw allow 30003
ufw allow 30004
ufw allow 30005
ufw allow 30010/tcp
ufw allow 30011/udp
ufw allow 30020/tcp
ufw allow 30021/udp
ufw allow 32768:65535/tcp
ufw allow 32768:65535/udp
ufw allow "$sshport"
ufw allow 80
ufw allow 443
ufw --force enable

#Install fail2ban
apt install fail2ban -y

#Install unattended-upgrades
apt install unattended-upgrades
cat > /etc/apt/apt.conf.d/20auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "7";
APT::Periodic::Unattended-Upgrade "7";
APT::Periodic::Download-Upgradeable-Package "7";
APT::Periodic::AutocleanInterval "7";
EOF

systemctl start nkn-commercial.service
systemctl restart systemd-journald
apt-get autoremove -y
rm -- "$0"
