# NKN-Commercial startup script for VPS

This script is the fastest method to deploy nkn-commercial node at VPS. 
Adding this script when installing VPS will install nkn-commercial automatically at the first boot.
Please read the script and understand the command before use.

Thanks to no112358/ALLinONE-nknnode. This script is modified from no112358/ALLinONE-nknnode's script.
Please visit https://forum.nkn.org/t/allinone-nknnode-script-deploy-nodes-faster-with-your-own-chaindb/2753 for more details of create your own ChainDB host server. 

## Feature
- Install nkn-commercial automatically at first boot. 
- No need to login root to install. User will be added in `/sbin/nologin`, no other setup needed.
- Most suitable to VPS provider without support of One-Click Deploy. Tested on Vultr, UpCloud and Linode server.
- No Fee, No Donation.  Use as you like. Feel free to change the script to suit your purpose. 

## Requirement
- Fresh VPS - At least 1 core CPU / 1 gb memory/ 25 gb storage
- Ubuntu 20.04/ Debian 10 (Debian has smaller size of OS, save spave up to ~1 GB)
- Root SSH key (essential)
- NKN beneficiary wallet address
- ChainDB if available. (please refer to https://github.com/no112358/ALLinONE-nknnode)

## Attention
- For security purpose, password login is prohited after installation. Please make sure you have SSH key of your VPS before deploy. 

## Installation
1. Open [startupscript.txt](https://github.com/durianpool/nkn-commercial/blob/main/startupscript.txt) by text editor. 
2. <b>Insert your NKN beneficiary wallet address</b> `benaddress="<Your Beneficiary Wallet Addr>"`
3. Change `sshport="22"`. (DDOS attack may consume your monthly bandwidth usage)
4. Insert your ChainDB host url if applicable. `websource=""`
5. Copy & paste the script to your VPS setup page at script option.
6. Choose your VPS setup. Remember pick the startup script option at setup.
7. Deploy

## Check Status and Pay ID Generation Fee
- After 15 to 30  minutes, installation of nkn-commercial will be finished. 
- Then, download of ChainDB from your host server will be started, if applicable. 
- Check status of your node.
   - Method: Key in node's ip address at http://nstatus.org/ and check. Message of request ID generation fee will prompt after all installation are completely done.
- After payment,  wait for ID generation and activation.
- If ChainDB sync from height 0, it will take few days to become state "PERSIST_FINISHED".

## Debugging/Maintenance
1. Login to your root by SSH Key.
2. wallet.json & wallet.pswd is located at `/home/nkn/nkn-commercial/services/nkn-node` folder. Suggest you make backup of both files outside the VPS. You may need it when you want to change server. Navigate to it with command: `cd "$(find / -type d -name "nkn-node")"`
3.  Check node status at terminal. `systemctl status nkn-commercial`
4. Stop nkn-commercial when doing maintance like backup wallet or replace ChainDB. `systemctl stop nkn-commercial`
5. Restart nkn-ccomercial after maintanance. `systemctl start nkn-commercial` or `systemctl restart nkn-commercial`
6. Check node status at http://nstatus.org/

## Remarks
- Please tell me if you success to deploy node at VPS provider besides Vultr, UpCloud or Linode. I will update README.
- I only have beginner level knowledge at Linux. Please tell me if you found bugs in the script. Thank you. 
- Contact: https://durianpool.github.io/#contact
