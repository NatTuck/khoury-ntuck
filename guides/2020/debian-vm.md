---
layout: default
---

# Installing a Debian 10 VM

## 1. Install a Virtual Machine Manager

 * Get VirtualBox for your operating system from https://www.virtualbox.org/
 * This guide was written using VirtualBox 6.0.8 ; make sure you've got >= 6.0
 * Install it.

## 2. Get the Debian install CD.

 * Debian is available from http://www.debian.org/
 * You're looking a CD image (.iso file) labeled Debian 10 amd64 netinst.
 * Download that and remember where you saved it.

## 3. Install Debian in VirtualBox

 * Open VirtualBox.
 * Hit "New".
 * Pick a name for your vm (eg. "debian10" or "cs3650hw").
 * Allocate at least 2GB of RAM and at least 20GB in a new virtual hard disk.
 * Open the settings for your new VM and do the following:
   * Verify you've allocated >= 2GB of RAM
   * Allocate at least 2 processors. If your machine only has two cores,
     set a processor "execution cap" at 75%.
   * Allocate at least 64 MB of video memory.
   * Make sure the graphics controller is set to "VMSVGA".
   * Set the virtual CD drive to point to your Debian install CD.
 * Hit "Start" to boot your VM.
 * Start the "Graphical Install".
 * Select your language, location, keyboard, and hostname.
 * Domain name can be left blank.
 * Leave root password blank.
 * Add a user account with a password.
 * Set time zone.
 * For partitioning, use "Guided - entire disk" and "All files in one partition"
 * The default debian mirror is fine.
 * No HTTP proxy.
 * When you get to software selection:
   * Make sure "standard system tools" and "Debian desktop environment" are selected.
   * Select at least the Xfce desktop environment.
 * Install the boot loader on the virtual disk.
 * Let the installer reboot you into your new system.

Here are some guides with screenshots in case you need them. Note that these
may not quite follow the directions above.

 - [Installing an OS in Virtualbox](https://brb.nci.nih.gov/seqtools/installUbuntu.html)
 - [Installing Debian 10](https://www.linuxtechi.com/debian-10-buster-installation-guide/)

## 4. Install VirtualBox Guest Additions

 * Log in to your user account.
 * From the VirtualBox Devices menu, pick "Insert Guest Additions CD".
 * Open a terminal
 * Install some required packages:

```
  you@vm:~$ sudo apt install build-essential linux-headers-amd64 dkms
```
 
 
 * cd to the guest additions CD (probably /media/cdrom0).
 * Run the installer:

```
  you@vm:/media/cdrom0$ sudo bash ./VBoxLinuxAdditions.run
```
 
 * Reboot the VM
 * Maximize the VM window. The VM display should resize with the window.

## 5. Install some common development packages

 * Open a terminal, and:
 
```
  you@vm:~$ sudo apt install build-essential vim-nox manpages-dev glibc-doc
  you@vm:~$ sudo apt install perl-doc valgrind clang-tools libautodie-perl
```

 * Optionally, set vim as your default editor.

```
  you@vim:~$ sudo update-alternatives --config editor
  (pick vim.nox)
```

## 6. A note on using "sudo".

If you've correctly followed the directions above, you'll have created two user
accounts on your system:

 * "root", a special account which can do system adminstration tasks.
 * A user account.

Since you didn't specify a password for root, you can't log in directly with
that account. This is good - most programs expect you to run as a normal user,
and can behave strangely if you run them as root. 

To run commands as root, you can prefix them in the terminal with "sudo". This
is nessiary for some tasks like installing new packages with "apt", but isn't
something you should do for normal commands like compiling and running programs.

Avoid running commands with "sudo" unless you're sure it's nessiary. New files
created by programms running as root generally are marked as being owned by
root. Your normal account won't be able to change or remove them. This can be
annoying to fix.

