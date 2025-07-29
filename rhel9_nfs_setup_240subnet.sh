#!/bin/bash

echo "🔧 Updating system..."
sudo dnf update -y

echo "📦 Installing NFS server and firewall tools..."
sudo dnf install -y nfs-utils firewalld

echo "🚀 Enabling and starting NFS and firewalld..."
sudo systemctl enable --now nfs-server firewalld

echo "🔥 Opening NFS-related services in firewall..."
sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=mountd
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --reload

echo "📁 Creating NFS export directory..."
sudo mkdir -p /mnt/pronto_share
sudo chown nobody:nobody /mnt/pronto_share
sudo chmod 777 /mnt/pronto_share

echo "📝 Configuring /etc/exports for 10.10.240.0/24..."
echo "/mnt/pronto_share 10.10.240.0/24(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports

echo "📡 Exporting NFS share..."
sudo exportfs -rav

echo "✅ NFS Share Ready: /mnt/pronto_share for subnet 10.10.240.0/24"
