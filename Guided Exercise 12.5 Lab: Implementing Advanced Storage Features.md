# Guided Exercise 12.5 Lab: Implementing Advanced Storage Features

In this exercise, you will use the Stratis storage management solution to create file systems that grow to accommodate increased data demands, and Virtual Data Optimizer to create volumes for efficient utilization of storage space.

## Outcomes

You should be able to:

- Create a thinly provisioned file system using Stratis storage management solution.

- Verify that the Stratis volumes grow dynamically to support real-time data growth.

- Access data from the snapshot of a thinly provisioned file system.

- Create a volume using Virtual Data Optimizer and mount it on a file system.

- Investigate the impact of data deduplication and compression on a Virtual Data Optimizer volume.

Log in to workstation as student using student as the password.

On workstation, run lab advstorage-review start to start the lab. This script sets up the environment correctly and ensures that the additional disks on serverb are clean.
```
[student@workstation ~]$ lab advstorage-review start
```

1. From workstation, open an SSH session to serverb as student.
```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

2. Switch to the root user.
```
[student@serverb ~]$ sudo -i
[sudo] password for student: student
[root@serverb ~]# 
```

3. Install the stratisd and stratis-cli packages using yum.
```
[root@serverb ~]# yum install stratisd stratis-cli
...output omitted...
Is this ok [y/N]: y
...output omitted...
Complete!
```

4. Start and enable the stratisd service using the systemctl command.
```
[root@serverb ~]# systemctl enable --now stratisd
```

5. Create the Stratis pool labpool containing the block device /dev/vdb.

5.1. Create the Stratis pool labpool using the stratis pool create command.
```
[root@serverb ~]# stratis pool create labpool /dev/vdb
```

5.2. Verify the availability of labpool using the stratis pool list command.
```
[root@serverb ~]# stratis pool list
Name                   Total Physical
labpool  5 GiB / 37.63 MiB / 4.96 GiB
```
Note the size of the pool in the preceding output.

6. Expand the capacity of labpool using the disk /dev/vdc available in the system.

6.1. Add the block device /dev/vdc to labpool using the stratis pool add-data command.
```
[root@serverb ~]# stratis pool add-data labpool /dev/vdc
```

6.2. Verify the size of labpool using the stratis pool list command.
```
[root@serverb ~]# stratis pool list
Name                    Total Physical
labpool  10 GiB / 41.63 MiB / 9.96 GiB
```
The preceding output shows that the size of labpool has increased after a new disk was added to the pool.

6.3. Use the stratis blockdev list command to list the block devices that are now members of labpool.
```
[root@serverb ~]# stratis blockdev list labpool
Pool Name  Device Node  Physical Size  Tier
labpool    /dev/vdb             5 GiB  Data
labpool    /dev/vdc             5 GiB  Data
```

7. Create a thinly provisioned file system named labfs in the labpool pool. Mount this file system on /labstratisvol so that it persists across reboots. Create a file named labfile1 that contains the text Hello World! on the labfs file system. Don't forget to use the x-systemd.requires=stratisd.service mount option in /etc/fstab.

7.1. Create the thinly provisioned file system labfs in labpool using the stratis filesystem create command. It may take up to a minute for the command to complete.
```
[root@serverb ~]# stratis filesystem create labpool labfs
```

7.2. Verify the availability of labfs using the stratis filesystem list command.
```
[root@serverb ~]# stratis filesystem list
Pool Name     Name                 Used     Created            Device                                     UUID
labpool  labfs  546 MiB  Mar 29 2019 07:48  /stratis/labpool/labfs  9825...d6ca
```

Note the current usage of labfs. This usage of the file system increases on-demand in the following steps.

7.3. Determine the UUID of labfs using the lsblk command.
```
[root@serverb ~]# lsblk --output=UUID /stratis/labpool/labfs
UUID
9825e289-fb08-4852-8290-44d1b8f0d6ca
```

7.4. Edit /etc/fstab so that the thinly provisioned file system labfs is mounted at boot time. Use the UUID you determined in the preceding step. The following shows the line you should add to /etc/fstab. You can use the vi /etc/fstab command to edit the file.
```
UUID=9825...d6ca /labstratisvol  xfs defaults,x-systemd.requires=stratisd.service 0 0
```

7.5. Create a directory named /labstratisvol using the mkdir command.
```
[root@serverb ~]# mkdir /labstratisvol
```

7.6. Mount the thinly provisioned file system labfs using the mount command to confirm that the /etc/fstab file contains the appropriate entries.
```
[root@serverb ~]# mount /labstratisvol
```

If the preceding command produces any errors, revisit the /etc/fstab file and ensure that it contains the appropriate entries.

7.7. Create a text file named /labstratisvol/labfile1 using the echo command.
```
[root@serverb ~]# echo "Hello World!" > /labstratisvol/labfile1
```

8. Verify that the thinly provisioned file system labfs dynamically grows as the data on the file system grows by adding a 2 GiB labfile2 to the filesystem.

8.1. View the current usage of labfs using the stratis filesystem list command.
```
[root@serverb ~]# stratis filesystem list
Pool Name     Name                 Used     Created            Device                                     UUID
labpool  labfs  546 MiB  Mar 29 2019 07:48  /stratis/labpool/labfs  9825...d6ca
```

8.2. Create a 2 GiB file in labfs using the dd command. It may take up to a minute for the command to complete.
```
[root@serverb ~]# dd if=/dev/urandom of=/labstratisvol/labfile2 bs=1M count=2048
```

8.3. Verify that the usage of labfs has increased, using the stratis filesystem list command.
```
[root@serverb ~]# stratis filesystem list
Pool Name     Name                 Used      Created            Device                                     UUID
labpool  labfs  2.53 GiB  Mar 29 2019 07:48  /stratis/labpool/labfs  9825...d6ca
```            

9. Create a snapshot named labfs-snap of the labfs file system. The snapshot allows you to access any file that is deleted from labfs.

9.1. Create a snapshot of labfs using the stratis filesystem snapshot command. It may take up to a minute for the command to complete.
```
[root@serverb ~]# stratis filesystem snapshot labpool \
labfs labfs-snap
```

9.2. Verify the availability of the snapshot using the stratis filesystem list command.
```
[root@serverb ~]# stratis filesystem list
...output omitted...
labpool  labfs-snap  2.53 GiB  Mar 29 2019 10:28  /stratis/labpool/labfs-snap  291d...8a16
```

9.3. Remove the /labstratisvol/labfile1 file.
```
[root@serverb ~]# rm /labstratisvol/labfile1
rm: remove regular file '/labstratisvol/labfile1'? y
```

9.4. Create the /labstratisvol-snap directory using the mkdir command.
```
[root@serverb ~]# mkdir /labstratisvol-snap
```

9.5. Mount the snapshot labfs-snap on /labstratisvol-snap using the mount command.
```
[root@serverb ~]# mount /stratis/labpool/labfs-snap \
/labstratisvol-snap
```

9.6. Confirm that you can still access the file you deleted from labfs using the snapshot labfs-snap.
```
[root@serverb ~]# cat /labstratisvol-snap/labfile1
Hello World!
```

10. Create the VDO volume labvdo, with the device /dev/vdd. Set its logical size to 50 GB.

10.1. Create the volume labvdo using the vdo create command.
```
[root@serverb ~]# vdo create --name=labvdo --device=/dev/vdd --vdoLogicalSize=50G
...output omitted...
```

10.2. Verify the availability of the volume labvdo using the vdo list command.
```
[root@serverb ~]# vdo list
labvdo
```

11. Mount the volume labvdo on /labvdovol with the XFS file system so that it persists across reboots. Don't forget to use the x-systemd.requires=vdo.service mount option in /etc/fstab.

11.1. Format the labvdo volume with the XFS file system using the mkfs command.
```
[root@serverb ~]# mkfs.xfs -K /dev/mapper/labvdo
...output omitted...
```

11.2. Use the udevadm command to register the new device node.
```
[root@serverb ~]# udevadm settle
```

11.3. Create the /labvdovol directory using the mkdir command.
```
[root@serverb ~]# mkdir /labvdovol
```

11.4. Determine the UUID of labvdo using the lsblk command.
```
[root@serverb ~]# lsblk --output=UUID /dev/mapper/labvdo
UUID
ef8cce71-228a-478d-883d-5732176b39b1
```

11.5. Edit /etc/fstab so that labvdo is mounted at boot time. Use the UUID of the volume you determined in the preceding step. The following shows the line you should add to /etc/fstab. You can use the vi /etc/fstab command to edit the file.
```
UUID=ef8c...39b1 /labvdovol xfs defaults,x-systemd.requires=vdo.service 0 0
```

11.6. Mount the labvdo volume using the mount command to confirm that the /etc/fstab file contains the appropriate entries.
```
[root@serverb ~]# mount /labvdovol
```

If the preceding command produces any errors, revisit the /etc/fstab file and ensure that it contains the appropriate entries.

12. Create three copies of the file named /root/install.img on the volume labvdo. Compare the statistics of the volume to verify the data deduplication and compression happening on the volume.

12.1. View the initial statistics and status of the volume using the vdostats command.
```
[root@serverb ~]# vdostats --human-readable
Device                    Size      Used Available Use% Space saving%
/dev/mapper/labvdo          5.0G      3.0G      2.0G  60%           99%
```
Notice that 3 GB of the volume is already used because when created, the VDO volume reserves 3-4 GB for itself. Also note that the value 99% in the Space saving% field indicates that you have not created any content so far in the volume, contributing to all of the saved volume space.

12.2. Copy /root/install.img to /labvdovol/install.img.1 and verify the statistics of the volume. It may take up to a minute to copy the file.
```
[root@serverb ~]# cp /root/install.img /labvdovol/install.img.1
[root@serverb ~]# vdostats --human-readable
Device                    Size      Used Available Use% Space saving%
/dev/mapper/labvdo          5.0G      3.4G      1.6G  68%            5%
```
Notice that the value of the Used field increased from 3.0G to 3.4G because you copied a file in the volume, and that occupies some space. Also, notice that the value of Space saving% field decreased from 99% to 5% because initially there was no content in the volume, contributing to the low volume space utilization and high volume space saving until you created a file in there. The volume space saving is quite low because you created a unique copy of the file in the volume and there is nothing to deduplicate.

12.3. Copy /root/install.img to /labvdovol/install.img.2 and verify the statistics of the volume. It may take up to a minute to copy the file.
```
[root@serverb ~]# cp /root/install.img /labvdovol/install.img.2
[root@serverb ~]# vdostats --human-readable
Device                    Size      Used Available Use% Space saving%
/dev/mapper/labvdo          5.0G      3.4G      1.6G  68%           51%
```

Notice that the used volume space did not change. Instead, the percentage of the saved volume space increased, proving that the data deduplication occurred to reduce the space consumption for the redundant copies of the same file. The value of Space saving% in the preceding output may vary on your system.

13. Reboot serverb. Verify that your labvdo volume is mounted on /labvdovol after the system starts back up.

13.1. Reboot the serverb machine.
```
[root@serverb ~]# systemctl reboot
```

NOTE
Note: If on a reboot, serverb does not boot to a regular login prompt but instead has "Give root password for maintenance (or press Control-D to continue):" you likely made a mistake in /etc/fstab. After providing the root password of redhat, you will need to remount the root file system as read-write with:
```
[root@serverb ~]# mount -o remount,rw /
```

Verify that /etc/fstab is configured correctly as specified in the solutions. Pay special attention to the mount options for the lines related to /labstratisvol and /labvdovol.

## Evaluation

On workstation, run the lab advstorage-review grade command to confirm success of this exercise.
```
[student@workstation ~]$ lab advstorage-review grade
```

## Finish

On workstation, run lab advstorage-review finish to complete this exercise. This script deletes the partitions and files created throughout the exercise and ensures that the environment is clean.
```
[student@workstation ~]$ lab advstorage-review finish
```
This concludes the lab.

