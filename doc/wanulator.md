```
Created by Calin Schurig on 17 Feb 2026
```


# Wanulator Configuration

This documentation outlines how the Juulink Capstone team modeled internet link degredation using version 2.4 of the [WANulator](https://wanulator.de/) project. This was done inside of a Proxmox virtual machine.

## Proxmox setup

TODO: have Mason fill this in.

## WANulator setup

To communicate with the WANulator inside of the virtual environment, we used a serial connection. To enable this, we had to make the following changes:

* Enable the virtual serial connection on the host:
```bash
qm set <VMID> -serial0 socket   
```
* Enable the virtual serial connection in the WANulator boot image (at <WANULATOR_BOOT_IMAGE>/isolinux/isolinux.cfg), which may require repacking:
```
DEFAULT live
SAY Booting WANulator now...
LABEL live
  menu label ^Wanulator
  kernel /casper/vmlinuz
  append  console=tty0 console=ttyS0,115200 file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd --
#   above line changed from
# append  file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd --
DISPLAY isolinux.txt
# TIMEOUT 300
PROMPT 0
```

## WANulator Interface

The WANulator has an executable named `wanulator2-headless` (located at /root/wanulator2-headless) that allows loading configurations for the WANulator, such as which interfaces are passing through to each other and how packets are manipulated/delayed/dropped as they pass through. This is the interface we are primarily concerned with. 

To execute commands in the WANulator virtual machines, you must first login to the serial terminal. To that end, two helper scripts have been developed.

* [send_cmd.expect](../failover/send_cmd.expect)
* [cp_file.expect](../failover/cp_file.expect)

These helper scripts take three arguments, a VMID number, a password, and a command/file. They automatically login to the VM, execute the command / copy over a file, and then logout, so that the next command can also login.

