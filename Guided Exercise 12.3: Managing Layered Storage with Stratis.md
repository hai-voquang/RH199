# Guided Exercise 12.3: Managing Layered Storage with Stratis

In this exercise, you will use Stratis to create file systems from pools of storage provided by physical storage devices.

## Outcomes

You should be able to:

- Create a thin-provisioned file system using Stratis storage management solution.

- Verify that the Stratis volumes grow dynamically to support real-time data growth.

- Access data from the snapshot of a thin-provisioned file system.

Log in to workstation as student using student as the password.

On workstation, run lab advstorage-stratis start to start the exercise. This script sets up the environment correctly and ensures that the additional disks on servera are clean.
```
[student@workstation ~]$ lab advstorage-stratis start
```

1. From workstation, open an SSH session to servera as student.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Switch to the root user.
```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

3. Install the stratisd and stratis-cli packages using the yum command.
```
[root@servera ~]# yum install stratisd stratis-cli
...output omitted...
Is this ok [y/N]: y
...output omitted...
Complete!
```

4. Activate the stratisd service using the systemctl command.
```
[root@servera ~]# systemctl enable --now stratisd
```

5. Ensure that the stratispool1 Stratis pool exists with the block device /dev/vdb.

5.1. Create a Stratis pool named stratispool1 using the stratis pool create command.
```
[root@servera ~]# stratis pool create stratispool1 /dev/vdb
```

5.2. Verify the availability of stratispool1 using the stratis pool list command.
```
[root@servera ~]# stratis pool list
Name                        Total Physical
stratispool1  5 GiB / 37.63 MiB / 4.96 GiB
```

Note the size of the pool in the preceding output.

6. Expand the capacity of stratispool1 using the /dev/vdc block device.

6.1.Add the block device /dev/vdc to stratispool1 using the stratis pool add-data command.
```
[root@servera ~]# stratis pool add-data stratispool1 /dev/vdc
```

6.2.Verify the size of stratispool1 using the stratis pool list command.
```
[root@servera ~]# stratis pool list
Name                         Total Physical
stratispool1  10 GiB / 41.63 MiB / 9.96 GiB
```

As shown above, the stratispool1 pool size increased when you added the block device.

6.3. Verify the block devices that are currently members of stratispool1 using the stratis blockdev list command.
```
[root@servera ~]# stratis blockdev list stratispool1
Pool Name     Device Node  Physical Size  Tier
stratispool1  /dev/vdb             5 GiB  Data
stratispool1  /dev/vdc             5 GiB  Data
```

7. Add a thin-provisioned file system named stratis-filesystem1 in the pool stratispool1. Mount the file system on /stratisvol. Create a file on the stratis-filesystem1 file system named file1 containing the text Hello World!.

7.1. Create the thin-provisioned file system stratis-filesystem1 on stratispool1 using the stratis filesystem create command. It may take up to a minute for the command to complete.
```
[root@servera ~]# stratis filesystem create stratispool1 stratis-filesystem1
```

7.2. Verify the availability of stratis-filesystem1 using the stratis filesystem list command.
```
[root@servera ~]# stratis filesystem list
Pool Name     Name                 Used     Created            Device                                                  UUID
stratispool1  stratis-filesystem1  546 MiB  Mar 29 2019 07:48  /stratis/stratispool1/stratis-filesystem1  8714...e7db
```

Note the current usage of stratis-filesystem1. This usage of the file system increases on-demand in the following steps.

7.3. Create a directory named /stratisvol using the mkdir command.
```
[root@servera ~]# mkdir /stratisvol
```

7.4. Mount stratis-filesystem1 on /stratisvol using the mount command.
```
[root@servera ~]# mount /stratis/stratispool1/stratis-filesystem1 /stratisvol
```

7.5. Verify that the stratis-filesystem1 volume is mounted on /stratisvol using the mount command.
```
[root@servera ~]# mount
...output omitted...
/dev/mapper/stratis-1-5c0e...12b9-thin-fs-8714...e7db on /stratisvol type xfs (rw,relatime,seclabel,attr2,inode64,sunit=2048,swidth=2048,noquota)
```

7.6. Create the text file /stratisvol/file1 using the echo command.
```
[root@servera ~]# echo "Hello World!" > /stratisvol/file1
```

8. Verify that the thin-provisioned file system stratis-filesystem1 dynamically grows as the data on the file system grows.

8.1. View the current usage of stratis-filesystem1 using the stratis filesystem list command.
```
[root@servera ~]# stratis filesystem list
Pool Name     Name                 Used     Created            Device                                     UUID
stratispool1  stratis-filesystem1  546 MiB  Mar 29 2019 07:48  /stratis/stratispool1/stratis-filesystem1  8714...e7db
```

8.2. Create a 2 GiB file on stratis-filesystem1 using the dd command. It may take up to a minute for the command to complete.
```
[root@servera ~]# dd if=/dev/urandom of=/stratisvol/file2 bs=1M count=2048
```

8.3. Verify the usage of stratis-filesystem1 using the stratis filesystem list command.
```
[root@servera ~]# stratis filesystem list
Pool Name     Name                 Used      Created            Device                                     UUID
stratispool1  stratis-filesystem1  2.53 GiB  Mar 29 2019 07:48  /stratis/stratispool1/stratis-filesystem1  8714...e7db
```            
The preceding output shows that the usage of stratis-filesystem1 has increased. The increase in the usage confirms that the thin-provisioned file system has dynamically expanded to accommodate the real-time data growth you created with /stratisvol/file2.

9. Create a snapshot of stratis-filesystem1 named stratis-filesystem1-snap. The snapshot will provide you with access to any file that is deleted from stratis-filesystem1.

9.1. Create a snapshot of stratis-filesystem1 using the stratis filesystem snapshot command. It may take up to a minute for the command to complete.

The following command is long and should be entered as a single line.
```
[root@servera ~]# stratis filesystem snapshot stratispool1 stratis-filesystem1 stratis-filesystem1-snap
```

9.2. Verify the availability of the snapshot using the stratis filesystem list command.
```
[root@servera ~]# stratis filesystem list
...output omitted...
stratispool1  stratis-filesystem1-snap  2.53 GiB  Mar 29 2019 10:28  /stratis/stratispool1/stratis-filesystem1-snap  291d...8a16
```

9.3. Remove the /stratisvol/file1 file.
```
[root@servera ~]# rm /stratisvol/file1
rm: remove regular file '/stratisvol/file1'? y
```

9.4. Create the directory /stratisvol-snap using the mkdir command.
```
[root@servera ~]# mkdir /stratisvol-snap
```

9.5. Mount the stratis-filesystem1-snap snapshot on /stratisvol-snap using the mount command.

The following command is long and should be entered as a single line.
```
[root@servera ~]# mount /stratis/stratispool1/stratis-filesystem1-snap /stratisvol-snap
```

9.6. Confirm that you can still access the file you deleted from stratis-filesystem1 using the stratis-filesystem1-snap snapshot.
```
[root@servera ~]# cat /stratisvol-snap/file1
Hello World!
```

10. Unmount /stratisvol and /stratisvol-snap using the umount command.
```
[root@servera ~]# umount /stratisvol-snap
[root@servera ~]# umount /stratisvol
```

11. Remove the thin-provisioned file system stratis-filesystem1 and its snapshot stratis-filesystem1-snap from the system.

11.1. Destroy stratis-filesystem1-snap using the stratis filesystem destroy command.
```
[root@servera ~]# stratis filesystem destroy stratispool1 stratis-filesystem1-snap
```

11.2. Destroy stratis-filesystem1 using the stratis filesystem destroy command.
```
[root@servera ~]# stratis filesystem destroy stratispool1 stratis-filesystem1
```

11.3. Exit the root user's shell and log out of servera.
```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab advstorage-stratis finish command to complete this exercise. This script deletes the partitions and files created throughout the exercise and ensures that the environment is clean.
```
[student@workstation ~]$ lab advstorage-stratis finish
```

This concludes the guided exercise.

