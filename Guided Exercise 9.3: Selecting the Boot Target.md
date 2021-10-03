# Guided Exercise 9.3: Selecting the Boot Target

In this exercise, you will determine the default target into which a system boots, and boot that system into other targets.

## Outcomes

You should be able to update the system default target and use a temporary target from the boot loader.

Log in as the student user on workstation using student as the password.

On workstation, run the lab boot-selecting start command. This command runs a start script that prepares workstation for the exercise.

```
[student@workstation ~]$ lab boot-selecting start
```

1. On workstation, open a terminal and confirm that the default target is graphical.target.

```
[student@workstation ~]$ systemctl get-default
graphical.target
```

2. On workstation, switch to the multi-user target manually without rebooting. Use the sudo command and if prompted, use student as the password.

```
[student@workstation ~]$ sudo systemctl isolate multi-user.target
[sudo] password for student: student
```

3. Access a text-based console. Use the Ctrl+Alt+F1 key sequence using the relevant button or menu entry. Log in as root using redhat as the password.

NOTE
Reminder: If you are using the terminal through a webpage you can click the Show Keyboard icon under your web browser’s url bar and then to the right of the machine’s IP address.

```
workstation login: root
Password: redhat
[root@workstation ~]# 
```

4. Configure workstation to automatically boot into the multi-user target, and then reboot workstation to verify. When done, change the default systemd target back to the graphical target.

4.1. Use the systemctl set-default command to set the default target.

```
[root@workstation ~]# systemctl set-default multi-user.target
Removed /etc/systemd/system/default.target.
Created symlink /etc/systemd/system/default.target -> /usr/lib/systemd/system/multi-user.target.
```

4.2. Reboot workstation.

```
[root@workstation ~]# systemctl reboot
```

Notice that after reboot the system presents a text-based console and not a graphical login anymore.

4.3. Log in as root using redhat as the password.

```
workstation login: root
Password: redhat
Last login: Thu Mar 28 14:50:53 on tty1
[root@workstation ~]# 
```

4.4. Set the default systemd target back to the graphical target.

```
[root@workstation ~]# systemctl set-default graphical.target
Removed /etc/systemd/system/default.target.
Created symlink /etc/systemd/system/default.target -> /usr/lib/systemd/system/graphical.target.
```

This concludes the first part of the exercise where you practice setting the default systemd target.

5. In this second part of the exercise, you will practice using rescue mode to recover the system.

Access the boot loader by rebooting workstation again. From within the boot loader menu, boot into the rescue target.

5.1. Initiate the reboot.

```
[root@workstation ~]# systemctl reboot
```

5.2. When the boot loader menu appears, press any key to interrupt the countdown (except Enter, which would initiate a normal boot).

5.3. Use the cursor keys to highlight the default boot loader entry.

5.4. Press e to edit the current entry.

5.5. Using the cursor keys, navigate to the line that starts with linux.

5.6. Press End to move the cursor to the end of the line.

5.7. Append systemd.unit=rescue.target to the end of the line.

5.8. Press Ctrl+x to boot using the modified configuration.

5.9. Log in to rescue mode. The root password is redhat You may need to hit enter to get a clean prompt.

```
Give root password for maintenance
(or press Control-D to continue): redhat
[root@workstation ~]# 
```

6. Confirm that in rescue mode, the root file system is in read/write mode.

```
[root@workstation ~]# mount
...output omitted...
/dev/vda3 on / type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
...output omitted...
```

7. Press Ctrl+d to continue with the boot process.

The system presents a graphical login. Log in as student using student as the password.

## Finish

On workstation, run the lab boot-selecting finish script to complete this exercise.

```
[student@workstation ~]$ lab boot-selecting finish
```

This concludes the guided exercise.

