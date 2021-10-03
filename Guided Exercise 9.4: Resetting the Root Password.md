# Guided Exercise 9.4: Resetting the Root Password

In this exercise, you will reset the root password on a system.

## Outcomes

You should be able to reset a lost root password.

Log in as the student user on workstation using student as the password.

On workstation, run the lab boot-resetting start command. This command runs a start script that determines if the servera machine is reachable on the network. It also resets the root password to a random string and sets a higher timeout for the GRUB2 menu.

```
[student@workstation ~]$ lab boot-resetting start
```

1. Reboot servera, and interrupt the countdown in the boot-loader menu.

1.1. Locate the icon for the servera console, as appropriate for your classroom environment. Open the console.

Send a Ctrl+Alt+Del to your system using the relevant button or menu entry.

1.2. When the boot-loader menu appears, press any key to interrupt the countdown, except Enter.

2. Edit the default boot-loader entry, in memory, to abort the boot process just after the kernel mounts all the file systems, but before it hands over control to systemd.

2.1. Use the cursor keys to highlight the default boot-loader entry.

2.2. Press e to edit the current entry.

2.3. Use the cursor keys to navigate to the line that starts with linux.

2.4. Press End to move the cursor to the end of the line.

2.5. Append rd.break to the end of the line.

2.6. Press Ctrl+x to boot using the modified configuration.

3. At the switch_root prompt, remount the /sysroot file system read/write, then use chroot to go into a chroot jail at /sysroot.

```
switch_root:/# mount -o remount,rw /sysroot
switch_root:/# chroot /sysroot
```

4. Change the root password back to redhat.

```
sh-4.4# passwd root
Changing password for user root.
New password: redhat
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: redhat
passwd: all authentication tokens updated successfully.
```

5. Configure the system to automatically perform a full SELinux relabel after boot. This is necessary because the passwd command recreates the /etc/shadow file without an SELinux context.

```
sh-4.4# touch /.autorelabel
```

6. Type exit twice to continue booting your system as usual. The system runs an SELinux relabel, then reboots again by itself. When the system is up, verify your work by logging in as root at the console. Use redhat as the password.

## Finish

On workstation, run the lab boot-resetting finish script to complete this exercise.

```
[student@workstation ~]$ lab boot-resetting finish
```

This concludes the guided exercise.

