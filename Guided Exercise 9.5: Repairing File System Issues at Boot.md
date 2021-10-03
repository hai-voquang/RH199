# Guided Exercise 9.5: Repairing File System Issues at Boot

In this exercise, you will recover a system from a misconfiguration in /etc/fstab that causes the boot process to fail.

## Outcomes

You should be able to diagnose /etc/fstab issues and use emergency mode to recover the system.

Log in as the student user on workstation using student as the password.

On workstation, run the lab boot-repairing start command. This command runs a start script that determines if the servera machine is reachable on the network. It also introduces a file-system issue, sets a higher timeout for the GRUB2 menu, and reboots servera.

```
[student@workstation ~]$ lab boot-repairing start
```

1. Access the servera console and notice that the boot process is stuck early on.

1.1 Locate the icon for the servera console, as appropriate for your classroom environment. Open the console.

Notice that a start job does not seem to complete. Take a minute to speculate about a possible cause for this behavior.

1.2. To reboot, send a Ctrl+Alt+Del to your system using the relevant button or menu entry. With this particular boot problem, this key sequence may not immediately abort the running job, and you may have to wait for it to time out before the system reboots.

If you wait for the task to time out without sending a Ctrl+Alt+Del, the system eventually spawns an emergency shell by itself.

1.3. When the boot-loader menu appears, press any key to interrupt the countdown, except Enter.

2. Looking at the error from the previous boot, it appears that at least parts of the system are still functioning. Because you know the root password, redhat, attempt an emergency boot.

2.1. Use the cursor keys to highlight the default boot loader entry.

2.2. Press e to edit the current entry.

2.3. Use the cursor keys to navigate to the line that starts with linux.

2.4. Press End to move the cursor to the end of the line.

2.5. Append systemd.unit=emergency.target to the end of the line.

2.6. Press Ctrl+x to boot using the modified configuration.

3. Log in to emergency mode. The root password is redhat.

```
Give root password for maintenance
(or press Control-D to continue): redhat
[root@servera ~]# 
```

4. Determine which file systems are currently mounted.

```
[root@servera ~]# mount
...output omitted...
/dev/vda1 on / type xfs (ro,relatime,seclabel,attr2,inode64,noquota)
...output omitted...
```

Notice that the root file system is mounted read-only.

5. Remount the root file system read/write.

```
[root@servera ~]# mount -o remount,rw /
```

6. Use the mount -a command to attempt to mount all the other file systems. With the --all (-a) option, the command mounts all the file systems listed in /etc/fstab that are not yet mounted.

```
[root@servera ~]# mount -a
mount: /RemoveMe: mount point does not exist.
```

7. Edit /etc/fstab to fix the issue.

7.1. Remove or comment out the incorrect line.

```
[root@servera ~]# vim /etc/fstab
...output omitted...
# /dev/sdz1   /RemoveMe   xfs   defaults   0 0
```

7.2. Update systemd for the system to register the new /etc/fstab configuration.

```
[root@servera ~]# systemctl daemon-reload
```

8. Verify that your /etc/fstab is now correct by attempting to mount all entries.

```
[root@servera ~]# mount -a
```

9. Reboot the system and wait for the boot to complete. The system should now boot normally.

```
[root@servera ~]# systemctl reboot
```

## Finish

On workstation, run the lab boot-repairing finish script to complete this exercise.

```
[student@workstation ~]$ lab boot-repairing finish
```

This concludes the guided exercise.
