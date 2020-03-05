#!/bin/bash

# mounts the partition on which pinn is installed
sudo mount /dev/mmcblk0p1 /media/pinn
cd /media/pinn
sudo cp autoboot_raspbian.txt autoboot.txt
cd
sudo umount /media/pinn
# for some reason reboot messes up GPi keys control on the second partition but shutdown now -r works
sudo killall emulationstation; sudo shutdown now -r
