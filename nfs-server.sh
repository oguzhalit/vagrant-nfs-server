#!/bin/bash
sudo apt update -y
sudo apt-get install nfs-kernel-server -y
mkdir -p /mnt/data
chown -R nobody:nogroup /mnt/data
chmod 777 /mnt/data
echo '/mnt/data	*(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)' >> /etc/exports
systemctl restart nfs-kernel-server
systemctl stop ufw

