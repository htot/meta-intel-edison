# Debian
>**Warning**: This image is not intended to be used for IOT but rather to use Edison board as a small server (Jenkins, Gerrit, web server, ...). It should be easier to install these packages on Debian rather than on Yocto image.  
>If you want to use Edison for IOT, stick to Yocto image!

### Prerequisite
``sudo apt install debootstrap``

### Build and flash
Follow the usual steps to generate a yocto image.  
Then type: ``make debian`` to generate the Debian image. The make requires sudo to run. So you may be asked for your password.  
During the process, you will be also asked to create the root password for Edison root account. You will need this password to login on Edison Debian.  
Use ``sudo out/linux64/build/toFlash/flashall.sh`` to flash it.  
You can type ``make clean_debian`` to delete the Debian image. It is required before calling ``make debian`` again.  

### Post install
You will have to:
* Create a user account: ``adduser an_username``
* Increase root partition size and if you want, add swap partition
    * If you plan to use a sdcard to increase storage space
      * Type the following commands to get full space for rootfs
         * ``parted /dev/mmcblk0 rm 9``
         * ``growpart /dev/mmcblk0 8 ``
         * ``resize2fs /dev/mmcblk0p8``
      * Create a swap partition on sdcard and mount main sdcard partition on /media
         * ``parted /dev/mmcblk1``
         * ``(parted) p`` to print the partition available on your sdcard
         * ``(parted) rm x`` where x is the number of a partition, repeat until you have removed all partitions
         * ``(parted) mkpart primary ext4 10 28000`` Create a main partition of 28GB 
         * ``(parted) mkpart primary linux-swap 28000 100%`` Create a swap partition from 28GB to the end (if you have a 32GB card, it will be 4GB)
         * ``(parted) q``
         * ``mkfs.ext4 /dev/mmcblk1p1`` format the main partition
         * ``mkswap /dev/mmcblk1p2`` format the swap partition
         * ``echo "/dev/mmcblk1p1 /media auto defaults 1 1" >> /etc/fstab mount main partition at startup at next reboot
         * ``echo "/dev/mmcblk1p2 none swap sw 0 0" >> /etc/fstab mount swap partition at next reboot
    * If you don't plan to use a sdcard
      * If you don't need swap partition. You can live with 1GB of RAM, and want more space to install packages.
          * ``parted /dev/mmcblk0 rm 9``
          * ``growpart /dev/mmcblk0 8 ``
          * ``resize2fs /dev/mmcblk0p8``
      * You need swap partition because 1GB of RAM may not be enough. We will transform update partition as a swap partition. You will have less space for packages.
          * ``mkswap  /dev/mmcblk0p9``
          * ``resize2fs /dev/mmcblk0p8``
          * ``echo "/dev/mmcblk0p9 none swap sw 0 0" >> /etc/fstab`` mount swap partition at next reboot
* Connect to wifi as usual with connmanctl
    * ``connmanctl``
    * ``connmanctl> enable wifi``
    * ``connmanctl> agent on``
    * ``connmanctl> scan wifi``
    * ``connmanctl> services`` once scan is completed
    * ``connmanctl> connect wifi_xxxx....``
    * ``Passphrase?`` Enter your SSID password
    * ``connmanctl> exit``

    
    

### Come back to Yocto
A recovery ``sudo toFlash\flash.all --recovery`` may be needed

### Notes
* Enjoy ``sudo apt update`` and ``sudo apt install package``
* Growing/resizing rootfs partition is needed only once. So no need to redo it if you reflash the same board.
* Your home folder for your user account is not deleted when reflashing.
* Debian buster can be installed but ``connman`` is not working, so connection to wifi is more tricky.




           
      
   

