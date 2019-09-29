 
wget http://cdimage.ubuntu.com/ubuntu-budgie/releases/18.10/release/ubuntu-budgie-18.10-desktop-amd64.iso -4
export iso_file=ubuntu-budgie-18.10-desktop-amd64.iso
mkdir mnt
sudo mount -o loop ${iso_file} mnt/
mkdir extract-cd
sudo rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd
mkdir squashfs
sudo unsquashfs mnt/casper/filesystem.squashfs
sudo mv squashfs-root edit
sudo mount --bind /dev/ edit/dev
sudo cp  startup.sh edit/usr/bin/
sudo chmod +x edit/usr/bin/startup.sh
sudo chroot edit /bin/bash -c "su - -c startup.sh"
sudo rm edit/usr/bin/startup.sh
sudo umount edit/dev
sudo echo "php" >> extract-cd/preseed/ubuntu-budgie.seed
sudo chmod +w extract-cd/casper/filesystem.manifest
sudo chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest
sudo mksquashfs edit extract-cd/casper/filesystem.squashfs
export output_file=ubuntu-budgie-18.10-desktop-apache-remix-amd64.iso
 
#export IMAGE_NAME="Ubuntu Budgie 18.10"
#sudo sed -i -e "s/$IMAGE_NAME/$IMAGE_NAME (Apache Remix)/" extract-cd/README.diskdefines
#sudo sed -i -e "s/$IMAGE_NAME/$IMAGE_NAME (Apache Remix)/" extract-cd/.disk/info
cd extract-cd
sudo rm -f md5sum.txt
(find -type f -print0 | xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee ../md5sum.txt)
mv -f ../md5sum.txt ./
# If the following is not done, causes an error in the boot menu disk check option
sed -i -e '/isolinux/d' md5sum.txt
export IMAGE_NAME="Ubuntu Budgie 18.04 apache-remix amd64"
genisoimage -r -V "Ubuntu Budgie 18.10" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -o ../${output_file} .
cd ..
isohybrid --uefi ubuntu-budgie-18.10-desktop-apache-remix-amd64.iso
umount squashfs/
umount mnt/
exit
echo "done"
 

