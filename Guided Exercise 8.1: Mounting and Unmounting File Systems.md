# Guided Exercise 8.1: Mounting and Unmounting File Systems

In this exercise, you will practice mounting and unmounting file systems.

## Outcomes

You should be able to identify and mount a new file system at a specified mount point, then unmount it.

Log in as the student user on workstation using student as the password.

From workstation, run the lab fs-mount start command. The command runs a start script that determines if the host, servera, is reachable on the network. The script also creates a partition on the second disk attached to servera.

```
[student@workstation ~]$ lab fs-mount start
```

1. Use the ssh command to log in to servera as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. A new partition with a file system has been added to the second disk (/dev/vdb) on servera. Mount the newly available partition by UUID at the newly created mount point /mnt/newspace.

2.1. Use the sudo -i command to switch to root, as only the root user can manually mount a device.

```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

2.2. Create the /mnt/newspace directory.

```
[root@servera ~]# mkdir /mnt/newspace
```

2.3. Use the lsblk command with the -fp option to discover the UUID of the device, /dev/vdb1.

```
[root@servera ~]# lsblk -fp /dev/vdb
NAME        FSTYPE LABEL UUID                                 MOUNTPOINT
/dev/vdb                                                      
└─/dev/vdb1 xfs          a04c511a-b805-4ec2-981f-42d190fc9a65
```

2.4. Mount the file system by using UUID on the /mnt/newspace directory. Replace the UUID with that of the /dev/vdb1 disk from the previous command output.

```
[root@servera ~]# mount \
UUID="a04c511a-b805-4ec2-981f-42d190fc9a65" /mnt/newspace
```

2.5. Verify that the /dev/vdb1 device is mounted on the /mnt/newspace directory.

```
[root@servera ~]# lsblk -fp /dev/vdb
NAME        FSTYPE LABEL UUID                                 MOUNTPOINT
/dev/vdb                                                      
└─/dev/vdb1 xfs          a04c511a-b805-4ec2-981f-42d190fc9a65 /mnt/newspace
```

3. Change to the /mnt/newspace directory and create a new directory, /mnt/newspace/newdir, with an empty file, /mnt/newspace/newdir/newfile.

3.1. Change to the /mnt/newspace directory.

```
[root@servera ~]# cd /mnt/newspace
```

3.2. Create a new directory, /mnt/newspace/newdir.

```
[root@servera newspace]# mkdir newdir
```

3.3. Create a new empty file, /mnt/newspace/newdir/newfile.

```
[root@servera newspace]# touch newdir/newfile
```

4. Unmount the file system mounted on the /mnt/newspace directory.

4.1. Use the umount command to unmount /mnt/newspace while the current directory on the shell is still /mnt/newspace. The umount command fails to unmount the device.

```
[root@servera newspace]# umount /mnt/newspace
umount: /mnt/newspace: target is busy.
```

4.2. Change the current directory on the shell to /root.

```
[root@servera newspace]# cd
[root@servera ~]# 
```

4.3. Now, successfully unmount /mnt/newspace.

```
[root@servera ~]# umount /mnt/newspace
```

5. Exit from servera.

```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation]$ 
```

## Finish

On workstation, run the lab fs-mount finish script to complete this exercise.

```
[student@workstation ~]$ lab fs-mount finish
```

This concludes the guided exercise.

