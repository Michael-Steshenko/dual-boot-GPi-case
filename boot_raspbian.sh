#!/bin/bash

# mounts the partition on which pinn is installed
sudo mount /dev/mmcblk0p1 /media/pinn
cd /media/pinn
sudo cp autoboot_raspbian.txt autoboot.txt
cd
sudo umount /media/pinn
sudo killall emulationstation; sudo shutdown now -r
