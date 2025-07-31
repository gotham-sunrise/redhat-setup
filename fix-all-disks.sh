# Replace sda with sdb, sdc, sdd if needed
for disk in /dev/sdb /dev/sdc /dev/sdd; do
  echo "Wiping $disk..."
  wipefs -a "$disk"
  sgdisk --zap-all "$disk"
  dd if=/dev/zero of="$disk" bs=1M count=10
  parted "$disk" --script mklabel gpt
done

sync
