#!/bin/bash
# mounts the partition on which pinn is installed
sudo mount /dev/mmcblk0p1 /media/pinn 
cd /media/pinn
sudo cp autoboot_retropie.txt autoboot.txt
cd
sudo umount /media/pinn
sudo killall startx; sudo shutdown now -r
