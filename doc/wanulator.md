```
Created by Calin Schurig on 17 Feb 2026
```


# Wanulator Configuration

This documentation outlines how the Juulink Capstone team modeled internet link degredation using version 2.4 of the [WANulator](https://wanulator.de/) project. This was done inside of a Proxmox virtual machine.

## Proxmox setup

The Wanulator iso requires legacy boot options not provided by the hardware in use. Proxmox Virtual Environment is a Linux operating system that acts as a hypervisor. 

We were able to create 4 different virtual machines that allow legacy booting into the Wanulator isos. Each virtual machine was given 4GB of RAM, 2 processors, and 32 GB of space. Because the wanulator iso was made to run on just about anything and stay in RAM, most of the settings were kept as default. No operating system was actually installed onto the VMs.

We added 2 network cards, each with 4 ports, to be able to pass through many different ISPs to our devices. Each physical interface is then assigned to a virtual interface which is assigned to a virtual machine. To make these assignments, we had to edit the configuration file:
```bash
nano /etc/network/interfaces
```
And we made the following changes for each physical interface, exlcluding the first(nic0) which is used for internet access to the host machine:
```bash
auto enp1s0f0 inet manual
auto vmbr1
iface vmbr1 inet manual
        bridge-ports enp1s0f0
        bridge-stp off
        bridge-fd 0
```

Each of 4 virtual machines is given two virtual interfaces to be able to bridge together, which can be seen in the hardware section of the VM.

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

