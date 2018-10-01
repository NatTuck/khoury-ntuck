---
layout: default
---

# Computer Systems

## First Thing

 - Questions on the Homework?

## Start Slides

 - Go through to "Simple OS Example", then break from slides for
   info on ME / Secure Boot.

## The Computer Boot Process

### Early Boot: Old Plan

 - Processor starts @ BIOS
 - BIOS selects boot disk
 - Reads partition table, selects boot partition
   - limit, 4 partitions
 - Reads MBR, loads 1st-stage bootloader
   - limit, 2TB disks
 - 1st stage loads second stage
 - Second stage selects and loads kernel
 - OS Kernel is in control

### Early Boot: Modern Systems

 - Management Engine starts processor
 - Processor starts @ UEFI
 - UEFI selects boot disk
 - Reads GPT partition table, selects boot partition
 - Loads 1st stage bootloader, verifies signature
 - Transfers control to 1st stage.
 - 1st stage loads second stage.
 - 2nd stage loads kernel, after optionally verifying signature
 - OS Kernel is in control

### Management Engine

 - Embedded computer system for remote management. Has full access to
   system RAM and the main network port.
 - Allows Intel / AMD to offer remote management tools for enterprise customers
   that can't be disabled by local software configuration, or running the wrong OS,
   or the computer being off, etc. 
 - Actual payload is secret.
 - Safest to assume that Intel / AMD has a back door into any computer with their
   processors given access to the local network that computer is on.
 - In May, a security hole was discovered that gave full remote sub-OS access to
   any machine with Intel Active Management Technology enabled. AMT is one of
   the remote management products enabled by the ME. This potentially applied to
   any Intel "Core" era processor (Laptop, Desktop, Server), but only in
   "Enterprise" configurations where AMT was explicitly enabled.
   
https://www.theregister.co.uk/2017/05/01/intel_amt_me_vulnerability/
   
 - Intel doesn't support disabling the ME.
 - Attempts to disable the ME generally result in the computer rebooting after
   a few minutes with the ME reinitialized.
 - After the security thing was discovered in May, researchers found a hidden
   ME-disable procedure - which was later confirmed to be a US-government required
   processor feature. So it's now possible to disable the ME if you're paranoid 
   (and possibly willing to buy specific hardware).

http://blog.ptsecurity.com/2017/08/disabling-intel-me.html

### Secure Boot

 - UEFI fixes some major issues with BIOS
   - Disk size limit
   - Partition count limit
   - Being 30 years old 
 - But adds a sketchy new feature: Secure Boot
 - This feature had existed previously on phones, where
   it's called a "locked bootloader".
 - Computers with this feature can only boot signed operating system.
   code. Other operating system code won't load.

Signed by who?

 - Cryptographic keys that can be used to verify boot software are
   loaded by the device manufacturer.
 - On phones, that's generally manufacturer keys.
 - On machines sold with Windows, that's generally just a key from Microsoft.
 - On Chromebooks, it's a key from Google.
 - Some systems allow the user to load their own keys and thus sign
   their own boot software.

Why?

 - Some viruses have operated by overwriting the boot loader. Secure boot
   prevents such infected systems from booting up at all.
 - Other malware like keyloggers or remote access trojans like to run
   early in the boot process. This similarly prevents them from working.
 - Allows guarantees about *all* the software running on a system if the
   OS wants to enforce it - can require package signatures, iOS style.
 - Allows systems to make guarantees like "no screen capture software
   is running while playing a video", for "content protection".

Why not?

 - The practicality of resisting attacks by someone with physical access
   to a computer is limited. They could always do things like installing
   a *hardware* keylogger.
 - The person most likely to have physical access to a device and the
   ability to attempt an OS install is the owner.
 - Being "secure against the owner" so you can prevent them from installing
   their choice of operating system sounds like an anti-feature to me.

This produces an amusing result: The bootloader on Ubuntu CDs is signed
by Microsoft.

## Finish Slides

 - Through stuff.
 - We'll see how far we get.

## Linux Boot Process

 - An initial RAM disk is loaded.
 - Hardware is detected.
 - The root filesystem is mounted.
   - Show /dev/fstab
   - Show "mount"
     - /dev/sdb1 on / type ext4
     - /dev/sdb5 on /home type btrfs
     - /dev/sda1 on /data type ext4
   - Show "cfdisk /dev/sda"
   - Show "cfdisk /dev/sdb"
 - Process 1 (init) is started.
   - Init loads system services.
 - Services include:
   - sshd for remote logins
   - logind for local logins
   - A display manager for graphical logins
   - Various servers
   - Show /etc/rc2.d


