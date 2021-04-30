# NKN-Commercial startup script for VPS

This script is the fastest method to deploy nkn-commercial node at VPS. 
Adding this script when installing VPS will install nkn-commercial at the first boot.
Please read the script and understand the command before use.

###Thanks to no112358/ALLinONE-nknnode. This script is modified from no112358/ALLinONE-nknnode's script.

## Feature:
- Install nkn-commercial automatically at first boot. (No need to login root to install)
- Suitable for VPS provider without support of One-Click Deploy. Tested on Vultr and UpCloud.
- No FEE, No Donation. Use as you like. Feel free to change the script to suit your purpose. 
- Please tell me if you success to deploy node at VPS provder other than Vultr and UpCloud. I will update it at README.
 
## Requirement
- VPS
- At least 1 core CPU / 1 gb memory/ 25 gb storage
- Ubuntu 20.04 (other version may work, but not verified)
- root SSH key (essential)
- ChainDB if available. (please refer to https://github.com/no112358/ALLinONE-nknnode)

## Attention
- Please make sure you have SSH key of your VPS before deploy. Password login is prohited after installation.

## Installation
1. Open startupscript.txt by text editer. Copy & paste the script to your VPS setup page at script option.
2. Choose your VPS setup. Remember pick the startup script option at setup.
3. Deploy

## Check Status and Pay ID Generation Fee
- After 10 to 15 minutes, installation of nkn-commercial will be finished. Then, download of ChainDB from your host server will be started. 
- Check status of your node.
  Method 1. Key in node's ip address at http://nstatus.org/ and check. Message of request ID generation fee will prompt after all installation are completely done. 
  Method 2. Login root with SSH key and check with command `systemctl status nkn-commercial`
- After payment,  your node is ready to go.

## Debugging/Maintenance
1. wallet.json & wallet.pswd is in nkn-node folder. Locate it with command: `cd "$(find / -type d -name "nkn-node")"`
   Suggest you to backup both files outside the VPS. You may need it when you want to change server.
2. Check node status at terminal. `systemctl status nkn-commercial`
3. Stop nkn-commercial when doing maintance like backup wallet or replace ChainDB. `systemctl stop nkn-commercial`
4. Restart nkn-ccomercial after maintanance. `systemctl start nkn-commercial` or `systemctl restart nkn-commercial`
5. Check node status at http://nstatus.org/
