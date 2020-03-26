# dual-boot-GPi-case
Scripts for dual booting RetroPie and Raspbian on the GPi case with easy switching between the two, a script for the GPi controls on the Raspbian partition to act like a mouse, and improved SafeShutdown scripts for both OS.
I am using PINN (an improved version of NOOBS) as my boot-loader, and editing PINN files to boot into different partitions.

## installing the modified safe shutdown scripts
1) Install the regular safe shutdown script located here: https://github.com/RetroFlag/retroflag-picase on both of the partitions (follow the regular installation steps)
2) On the Raspbian partition replace the contents of the script in /opt/RetroFlag/SafeShutdown.py with the contents of SafeShutdown_gpi_raspbian.py
3) On the RetroPie partition replace the contents of the script in /opt/RetroFlag/SafeShutdown.py with the contents of SafeShutdown_gpi_retropie.py

notice that the file names should remain the same (SafeShutdown.py)

## installing the OS switch scripts
First we need to create some help text files for our scripts:  
mount the partition on which PINN/NOOBS is installed, if you used PINN to install multiple OSes it should be /dev/mmcblk0p1:
sudo mount /dev/mmcblk0p1 /media/pinn  
cd /media/pinn  
we need to create two text files:  
sudo nano autoboot_raspbian.txt  
in the text file write the following line: boot_partition=6  
replace 6 with the number of the partition on which raspbian is installed.  
press Ctrl+X, y to confirm and enter to save file.  

sudo nano autoboot_retropie.txt  
in the text file write the following line: boot_partition=8  
replace 8 with the number of the partition on which RetroPie is installed.  
press Ctrl+X, y to confirm and enter to save file.  

### configuring the script on RetroPie
Put the boot_raspbian.sh file from this git in /opt/retropie/configs/all/runcommand-menu of the RetroPie partition.  
chmod a+x /opt/retropie/configs/all/runcommand-menu/boot_raspbian.sh
restart emulationstation.  
You can now access the script by pressing a on your GPi case when launching any game, going to "User Menu" and selecting "boot_to_raspbian".  

### configuring the script on Raspbian
Put boot_retropie.sh script from this git, somewhere it would be easy for you to access, I put it on the Desktop. And make it excecutable:  
chmod a+x ~/Desktop/boot_retropie.sh  

You can now access the script by double clicking it in X, or running sh ~/Desktop/boot_retropie.sh from terminal.  

## connecting a blutooth keyboard to work with multiple partitions
Note: this step is optional  
1) boot into RetroPie and connect a blutooth keyboard using the GPi case keys and RetroPie menu  
2) ssh into the raspberry pi using another computer or press f4 on the blutooth keyboard to gain acess to the terminal (I recommend ssh, and I assume ssh throughout this section, though using a bluetooth keyboard should be somewhat similar)
you can find the ip using hostname -I or through showip in the RetroPie menu. 
3) now we need to locate where the info file for the blutooth device is saved, type in: 

sudo chmod -R 775 /var/lib/bluetooth

That will give write permission to the group if it's not there and read and execute to everyone else. You can modify the 775 to give whatever permissions you want to everyone else as that will be specified by the third number.

4) cd /var/lib/bluetooth
ls
you should see a folder that looks something like this: 
B8:27:EB:3D:A0:21 this address should correspond to the adress of the blutooth device you've connected, SAVE IT SOMEWHERE.

5) cd into it: 
cd B8:27:EB:3D:A0:21
ls
6) you should see another folder that looks something like this: 77:05:11:19:58:F1, cd into it:
cd 77:05:11:19:58:F1
SAVE THIS folder name somwhere
ls
7) you should see a single file that's called "info", view its contents with:
sudo nano info
you should see all the info from the blutooth device stored in this file, copy the contents of this file and save it somewhere on your local machine.

8) close the file using cntrl+x, if prompted if you want to save the file answear "No".

9) now we need to create this file on the other partition (or partitions) on the raspberry pi, for this we would need to mount the other partition.
type in "sudo fdisk -l" you should see a list looking something like this:

~~~
Device         Boot    Start       End   Sectors  Size Id Type
/dev/mmcblk0p1          8192    137215    129024   63M  e W95 FAT16 (LBA)
/dev/mmcblk0p2        137216 124735487 124598272 59.4G  5 Extended
/dev/mmcblk0p5        139264    204797     65534   32M 83 Linux
/dev/mmcblk0p6        204800    729085    524286  256M  c W95 FAT32 (LBA)
/dev/mmcblk0p7        729088  42614781  41885694   20G 83 Linux
/dev/mmcblk0p8      42614784  42731519    116736   57M  c W95 FAT32 (LBA)
/dev/mmcblk0p9      42737664 124735487  81997824 39.1G 83 Linux
~~~

the partition we are looking for is one of the partitions with type "Linux" and in this example there are 3 of those, we can rule out /dev/mmcblk0p5 because we see its size is 32M (this is the PINN recovery partition).
so it's either /dev/mmcblk0p7 or /dev/mmcblk0p9 for me it was /dev/mmcblk0p7 which I could tell by the 20G size I gave to that partition. If you are unsure on which partition you need you can just choose one randomly and try to mount it (explained in the next steps). you can ususally tell by the files which system it is, if you still can't figure it out, create a text file with some distinct name somewhere on the RetroPie partition, by going to the path of the file in the mounted directory you'd be able to tell if you mounted the RetroPie partition or the correct one.

10) mount the partition:

sudo mkdir /mnt/raspbian  
this will just create a folder, /mnt is just the convention folder to where we mount disks, and raspbian is just the name of the disk

sudo mount /dev/mmcblk0p7 /mnt/raspbian  
this mounts the mmcblk0p7 partition into the raspbian folder we just created.  

11) now we need to create the info file on this partition,  

cd /mnt/raspbian/var/lib/bluetooth  
if you get access denied error use sudo chmod -R 775 "path to folder"  

mkdir B8:27:EB:3D:A0:21 (the first folder name you've saved before)  
cd B8:27:EB:3D:A0:21  

mkdir 77:05:11:19:58:F1 (the second folder name you've saved before)  
cd 77:05:11:19:58:F1  

sudo nano info  
paste the contents of the info file you saved on your local machine  
press cntrl+X  
and press Y when prompted to save  

12) unmount the partition:  
cd outside the mounted partition:  

cd  

umount /mnt/raspbian  

13) boot into the other partition with the boot_raspbian script and check your bluetooth device is connected.  

## Installing the GPiMouse.sh script
This will allow the GPi controls to act as a mouse under Raspbian.
1) boot into raspbian

2) install xboxdrv:  
sudo apt-get update  
sudo apt-get install xboxdrv

3) place the GPiMouse.sh script from this repository in /opt/RetroFlag

4) sudo chmod a+x /opt/RetroFlag/GPiMouse.sh

4) now we make GPiMouse.sh run on startup: sudo nano /etc/rc.local

5) add the following lines after the sudo python3 /opt/RetroFlag/SafeShutdown.py & line:  
sudo sh /opt/RetroFlag/GPiMouse.sh
