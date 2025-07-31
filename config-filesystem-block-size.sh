#!/bin/bash

set -e

# Devices
SDA_PART="/dev/sda3"   # Or /dev/sda3 if OS uses /dev/sda1
SDB="/dev/sdb"
SDC="/dev/sdc"
SDD="/dev/sdd"

# Mount points
SDA_MNT="/mnt/sda_data"
SDB_MNT="/data1"
SDC_MNT="/data2"
SDD_MNT="/data3"

echo "Formatting $SDA_PART with 4K block size..."
mkfs.xfs -f -b size=4096 "$SDA_PART"

echo "Formatting $SDB, $SDC, $SDD with 64K block size..."
mkfs.xfs -f -b size=65536 "$SDB"
mkfs.xfs -f -b size=65536 "$SDC"
mkfs.xfs -f -b size=65536 "$SDD"

# Create mount points
mkdir -p "$SDA_MNT" "$SDB_MNT" "$SDC_MNT" "$SDD_MNT"

# Mount all
mount "$SDA_PART" "$SDA_MNT"
mount "$SDB" "$SDB_MNT"
mount "$SDC" "$SDC_MNT"
mount "$SDD" "$SDD_MNT"

# Add to /etc/fstab
echo "UUID=$(blkid -s UUID -o value $SDA_PART) $SDA_MNT xfs defaults 0 0" >> /etc/fstab
echo "UUID=$(blkid -s UUID -o value $SDB) $SDB_MNT xfs defaults 0 0" >> /etc/fstab
echo "UUID=$(blkid -s UUID -o value $SDC) $SDC_MNT xfs defaults 0 0" >> /etc/fstab
echo "UUID=$(blkid -s UUID -o value $SDD) $SDD_MNT xfs defaults 0 0" >> /etc/fstab

echo "✅ All filesystems created and mounted."
