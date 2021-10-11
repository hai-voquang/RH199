# Guided Exercise 12.4: Compressing and Deduplicating Storage with VDO

In this exercise, you will create a VDO volume, format it with a file system, mount it, store data on it, and investigate the impact of compression and deduplication on storage space actually used.

## Outcomes

You should be able to:

- Create a volume using Virtual Data Optimizer, format it with a file-system type, and mount a file system on it.

- Investigate the impact of data deduplication and compression on a Virtual Data Optimizer volume.

Log in to workstation as student using student as the password.

On workstation, run lab advstorage-vdo start to start the exercise. This script ensures that there are no partitions on the /dev/vdd disk and sets up the environment correctly.
```
[student@workstation ~]$ lab advstorage-vdo start
```

1. From workstation, open an SSH session to servera as student.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Create the VDO volume vdo1, using the /dev/vdd device. Set its logical size to 50 GB.

2.1. Switch to the root user.
```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

2.2. Confirm that the vdo package is installed using the yum command.
```
[root@servera ~]# yum list installed vdo
Installed Packages
vdo.x86_64        6.2.2.117-13.el8          @rhel-8-for-x86_64-baseos-rpms
```

2.3. Create the vdo1 volume using the vdo create command.
```
[root@servera ~]# vdo create --name=vdo1 \
--device=/dev/vdd --vdoLogicalSize=50G
...output omitted...
```

2.4. Verify the availability of the vdo1 volume using the vdo list command.
```
[root@servera ~]# vdo list
vdo1
```

3. Verify that the vdo1 volume has both the compression and deduplication features enabled.

Use grep to search for the lines containing the string Deduplication and Compression in the output of the vdo status --name=vdo1 command.
```
[root@servera ~]# vdo status --name=vdo1 \
| grep -E 'Deduplication|Compression'
    Compression: enabled
    Deduplication: enabled
```

4. Format the vdo1 volume with the XFS file-system type and mount it on /mnt/vdo1.

4.1. Use the udevadm command to verify that the new VDO device file has been created.
```
[root@servera ~]# udevadm settle
```

4.2. Format the vdo1 volume with the XFS file system using the mkfs command.
```
[root@servera ~]# mkfs.xfs -K /dev/mapper/vdo1
...output omitted...
```

The -K option in the preceding mkfs.xfs command prevents the unused blocks in the file system from being discarded immediately which lets the command return faster.

4.3. Create the /mnt/vdo1 directory using the mkdir command.
```
[root@servera ~]# mkdir /mnt/vdo1
```

4.4. Mount the vdo1 volume on /mnt/vdo1 using the mount command.
```
[root@servera ~]# mount /dev/mapper/vdo1 /mnt/vdo1
```

4.5. Verify that the vdo1 volume is successfully mounted using the mount command.
```
[root@servera ~]# mount
...output omitted...
/dev/mapper/vdo1 on /mnt/vdo1 type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
```

5. Create three copies of the same file named /root/install.img on the vdo1 volume. Compare the statistics of the volume to verify the data deduplication and compression happening on the volume. The preceding output may vary on your system..

5.1. View the initial statistics and status of the volume using the vdostats command.
```
[root@servera ~]# vdostats --human-readable
Device                    Size      Used Available Use% Space saving%
/dev/mapper/vdo1          5.0G      3.0G      2.0G  60%           99%
```

Notice that 3 GB of the volume is already used because when created, the VDO volume reserves 3-4 GB for itself. Also, note that the value 99% in the Space saving% field indicates that you have not created any content so far in the volume contributing to all of the saved volume space.

5.2. Copy /root/install.img to /mnt/vdo1/install.img.1 and verify the statistics of the volume. It may take up to a minute to copy the file.
```
[root@servera ~]# cp /root/install.img /mnt/vdo1/install.img.1
[root@servera ~]# vdostats --human-readable
Device                    Size      Used Available Use% Space saving%
/dev/mapper/vdo1          5.0G      3.4G      1.6G  68%            5%
```

Notice that the value of the Used field increased from 3.0G to 3.4G because you copied a file to the volume, and that occupies some space. Also, notice that the value of Space saving% field decreased from 99% to 5% because initially there was no content in the volume, contributing to the low volume space utilization and high volume space saving until you created a file. The volume space saving is considerably low because you created a unique copy of the file in the volume and there is nothing to deduplicate.

5.3. Copy /root/install.img to /mnt/vdo1/install.img.2 and verify the statistics of the volume. It may take up to a minute to copy the file.
```
[root@servera ~]# cp /root/install.img /mnt/vdo1/install.img.2
[root@servera ~]# vdostats --human-readable
Device                    Size      Used Available Use% Space saving%
/dev/mapper/vdo1          5.0G      3.4G      1.6G  68%           51%
```

Notice that the used volume space did not change rather the percentage of the saved volume space increased proving that the data deduplication occurred to reduce the space consumption for the redundant copies of the same file. The value of Space saving% in the preceding output may vary on your system.

5.4. Exit the root user's shell and log out of servera.
```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run lab advstorage-vdo finish to complete this exercise. This script deletes the files created throughout the exercise and ensures that the environment is clean.
```
[student@workstation ~]$ lab advstorage-vdo finish
```
This concludes the guided exercise.

