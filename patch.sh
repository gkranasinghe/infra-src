#!/bin/bash
sudo apt install -qq -y net-tools
sudo mknod /dev/kmsg c 1 11
echo 'mknod /dev/kmsg c 1 11' | sudo tee  /etc/rc.local
sudo chmod +x /etc/rc.local
sudo mount --make-rshared /
echo 'L /dev/kmsg - - - - /dev/console' > /etc/tmpfiles.d/kmsg.conf