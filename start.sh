 
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
export HOME=/root
export LC_ALL=C
echo "nameserver 1.1.1.1" >> /run/systemd/resolve/stub-resolv.conf
sudo apt update && sudo apt upgrade
sudo apt install php-fpm php
apt clean
rm -rf /tmp/*
rm -rf /var/cache/apt-xapian-index/*
rm -rf /var/lib/apt/lists/*
umount /proc
umount /sys
umount /dev/pts
 

