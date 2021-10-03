# Guided Exercise 8.4 Lab: Managing Basic Storage

## Performance Checklist

In this lab, you will create several partitions on a new disk, formatting some with file systems and mounting them, and activating others as swap spaces.

## Outcomes

You should be able to:

- Display and create partitions using the parted command.

- Create new file systems on partitions and persistently mount them.

- Create swap spaces and activate them at boot.

Log in to workstation as student using student as the password.

On workstation, run the lab storage-review start command. This command runs a start script that determines if the serverb machine is reachable on the network. It also prepares the second disk on serverb for the exercise.

```
[student@workstation ~]$ lab storage-review start
```

1. New disks are available on serverb. On the first new disk, create a 2 GB GPT partition named backup. Because it may be difficult to set the exact size, a size between 1.8 GB and 2.2 GB is acceptable. Set the correct file-system type on that partition to host an XFS file system.

The password for the student user account on serverb is student. This user has full root access through sudo.

1.1. Use the ssh command to log in to serverb as the student user. The systems are configured to use SSH keys for authentication, therefore a password is not required.

```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

1.2. Because creating partitions and file systems requires root access, use the sudo -i command to switch to the root user. If prompted, use student as the password.

```
[student@serverb ~]$ sudo -i
[sudo] password for student: student
[root@serverb ~]# 
```

1.3. Use the lsblk command to identify the new disks. Those disks should not have any partitions yet.

```
[root@serverb ~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sr0     11:0    1 1024M  0 rom
vda    252:0    0   10G  0 disk
└─vda1 252:1    0   10G  0 part /
vdb    252:16   0    5G  0 disk
vdc    252:32   0    5G  0 disk
vdd    252:48   0    5G  0 disk
```

Notice that the first new disk, vdb, does not have any partitions.

1.4. Confirm that the disk has no label.

```
[root@serverb ~]# parted /dev/vdb print
Error: /dev/vdb: unrecognised disk label
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: unknown
Disk Flags:
```

1.5. Use parted and the mklabel subcommand to define the GPT partitioning scheme.

```
[root@serverb ~]# parted /dev/vdb mklabel gpt
Information: You may need to update /etc/fstab.
```

1.6. Create the 2 GB partition. Name it backup and set its type to xfs. Start the partition at sector 2048.

```
[root@serverb ~]# parted /dev/vdb mkpart backup xfs 2048s 2GB
Information: You may need to update /etc/fstab.
```

1.7. Confirm the correct creation of the new partition.

```
[root@serverb ~]# parted /dev/vdb print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name    Flags
 1      1049kB  2000MB  1999MB               backup
```

1.8. Run the udevadm settle command. This command waits for the system to detect the new partition and to create the /dev/vdb1 device file. It only returns when it is done.

```
[root@serverb ~]# udevadm settle
[root@serverb ~]# 
```

2. Format the 2 GB partition with an XFS file system and persistently mount it at /backup.

2.1. Use the mkfs.xfs command to format the /dev/vbd1 partition.

```
[root@serverb ~]# mkfs.xfs /dev/vdb1
meta-data=/dev/vdb1              isize=512    agcount=4, agsize=121984 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=487936, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

2.2. Create the /backup mount point.

```
[root@serverb ~]# mkdir /backup
[root@serverb ~]# 
```

2.3. Before adding the new file system to /etc/fstab, retrieve its UUID.

```
[root@serverb ~]# lsblk --fs /dev/vdb1
NAME FSTYPE LABEL UUID                                 MOUNTPOINT
vdb1 xfs          a3665c6b-4bfb-49b6-a528-74e268b058dd
```

The UUID on your system is probably different.

2.4. Edit /etc/fstab and define the new file system.

```
[root@serverb ~]# vim /etc/fstab
...output omitted...
UUID=a3665c6b-4bfb-49b6-a528-74e268b058dd   /backup   xfs   defaults   0 0
```

2.5. Force systemd to reread the /etc/fstab file.

```
[root@serverb ~]# systemctl daemon-reload
[root@serverb ~]# 
```

2.6. Manually mount /backup to verify your work. Confirm that the mount is successful.

```
[root@serverb ~]# mount /backup
[root@serverb ~]# mount | grep /backup
/dev/vdb1 on /backup type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
```

3. On the same new disk, create two 512 MB GPT partitions named swap1 and swap2. A size between 460 MB and 564 MB is acceptable. Set the correct file-system type on those partitions to host swap spaces.

3.1. Retrieve the end position of the first partition by displaying the current partition table on /dev/vdb. In the next step, you use that value as the start of the swap1 partition.

```
[root@serverb ~]# parted /dev/vdb print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name    Flags
 1      1049kB  2000MB  1999MB  xfs          backup
```

3.2. Create the first 512 MB partition named swap1. Set its type to linux-swap. Use the end position of the first partition as the starting point. The end position is 2000 MB + 512 MB = 2512 MB

```
[root@serverb ~]# parted /dev/vdb mkpart swap1 linux-swap 2000MB 2512M
Information: You may need to update /etc/fstab.
```

3.3. Create the second 512 MB partition named swap2. Set its type to linux-swap. Use the end position of the previous partition as the starting point: 2512M. The end position is 2512 MB + 512 MB = 3024 MB

```
[root@serverb ~]# parted /dev/vdb mkpart swap2 linux-swap 2512M 3024M
Information: You may need to update /etc/fstab.
```

3.4. Display the partition table to verify your work.

```
[root@serverb ~]# parted /dev/vdb print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name    Flags
 1      1049kB  2000MB  1999MB  xfs          backup
 2      2000MB  2512MB  513MB                swap1   swap
 3      2512MB  3024MB  512MB                swap2   swap
```

3.5. Run the udevadm settle command. This command waits for the system to register the new partitions and to create the device files.

```
[root@serverb ~]# udevadm settle
[root@serverb ~]# 
```

4. Initialize the two 512 MiB partitions as swap spaces and configure them to activate at boot. Set the swap space on the swap2 partition to be preferred over the other.

4.1. Use the mkswap command to initialize the swap partitions.

```
[root@serverb ~]# mkswap /dev/vdb2
Setting up swapspace version 1, size = 489 MiB (512749568 bytes)
no label, UUID=87976166-4697-47b7-86d1-73a02f0fc803
[root@serverb ~]# mkswap /dev/vdb3
Setting up swapspace version 1, size = 488 MiB (511700992 bytes)
no label, UUID=4d9b847b-98e0-4d4e-9ef7-dfaaf736b942
```

Take note of the UUIDs of the two swap spaces. You use that information in the next step. If you cannot see the mkswap output anymore, use the lsblk --fs command to retrieve the UUIDs.

4.2. Edit /etc/fstab and define the new swap spaces. To set the swap space on the swap2 partition to be preferred over swap1, give it a higher priority with the pri option.

```
[root@serverb ~]# vim /etc/fstab
...output omitted...
UUID=a3665c6b-4bfb-49b6-a528-74e268b058dd   /backup xfs   defaults  0 0
UUID=87976166-4697-47b7-86d1-73a02f0fc803   swap    swap  pri=10    0 0
UUID=4d9b847b-98e0-4d4e-9ef7-dfaaf736b942   swap    swap  pri=20    0 0
```

4.3. Force systemd to reread the /etc/fstab file.

```
[root@serverb ~]# systemctl daemon-reload
[root@serverb ~]# 
```

4.4. Use the swapon -a command to activate the new swap spaces. Use the swapon --show command to confirm the correct activation of the swap spaces.

```
[root@serverb ~]# swapon -a
[root@serverb ~]# swapon --show
NAME      TYPE      SIZE USED PRIO
/dev/vdb2 partition 489M   0B   10
/dev/vdb3 partition 488M   0B   20
```

5. To verify your work, reboot serverb. Confirm that the system automatically mounts the first partition at /backup. Also, confirm that the system activates the two swap spaces.

When done, log off from serverb.

5.1. Reboot serverb.

```
[root@serverb ~]# systemctl reboot
[root@serverb ~]# 
Connection to serverb closed by remote host.
Connection to serverb closed.
[student@workstation ~]$ 
```

5.2. Wait a few minutes for serverb to reboot and then log in as the student user.

```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

5.3. Verify that the system automatically mounts /dev/vdb1 at /backup.

```
[student@serverb ~]$ mount | grep /backup
/dev/vdb1 on /backup type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
```

5.4. Use the swapon --show command to confirm that the system activates both swap spaces.

```
[student@serverb ~]$ swapon --show
NAME      TYPE      SIZE USED PRIO
/dev/vdb2 partition 489M   0B   10
/dev/vdb3 partition 488M   0B   20
```

5.5. Log off from serverb.

```
[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$ 
```

## Evaluation

On workstation, run the lab storage-review grade script to confirm success on this exercise.

```
[student@workstation ~]$ lab storage-review grade
```

## Finish

On workstation, run the lab storage-review finish script to complete the lab.

```
[student@workstation ~]$ lab storage-review finish
```

This concludes the lab.

