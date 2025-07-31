#!/bin/bash

set -e

# Define device-to-mountpoint mapping
declare -A mountpoints=(
  ["/dev/sdb"]="/testdb"
  ["/dev/sdc"]="/data01"
  ["/dev/sdd"]="/dbs"
)

echo "⏳ Mounting and persisting disks..."

for dev in "${!mountpoints[@]}"; do
  mp="${mountpoints[$dev]}"

  # Check if device exists
  if [ ! -b "$dev" ]; then
    echo "❌ Device $dev does not exist. Skipping."
    continue
  fi

  # Create mount point
  mkdir -p "$mp"

  # Mount the device
  echo "🔧 Mounting $dev to $mp..."
  mount "$dev" "$mp"

  # Get UUID
  uuid=$(blkid -s UUID -o value "$dev")
  if grep -q "$uuid" /etc/fstab; then
    echo "ℹ️  Entry for $uuid already exists in /etc/fstab. Skipping."
  else
    echo "✅ Persisting $dev ($uuid) to $mp in /etc/fstab"
    echo "UUID=$uuid $mp xfs defaults 0 0" >> /etc/fstab
  fi
done

# Verify mounts
echo -e "\n📊 Mounted Filesystems:"
df -hT | grep -E '/testdb|/data01|/dbs' || echo "⚠️  No matching mounts found."

echo -e "\n✅ Done."
