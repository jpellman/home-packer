#!/bin/bash

sudo mkdir /mnt/cdrom
sudo mount /dev/disk/by-label/VBox_GAs_$(cat ~/.vbox_version) /mnt/cdrom
sudo yum install -y tar bzip2 kernel-headers kernel-devel gcc make perl
sudo /bin/sh /mnt/cdrom/VBoxLinuxAdditions.run
sudo yum remove -y tar bzip2 kernel-headers kernel-devel gcc make perl
sudo umount /mnt/cdrom
sudo rmdir /mnt/cdrom
