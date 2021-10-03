
# Guided Exercise 8.2: Adding Partitions, File Systems, and Persistent Mounts

In this exercise, you will create a partition on a new storage device, format it with an XFS file system, configure it to be mounted at boot, and mount it for use.

## Outcomes

You should be able to use parted, mkfs.xfs, and other commands to create a partition on a new disk, format it, and persistently mount it.

Log in as the student user on workstation using student as the password.

On workstation, run the lab storage-partitions start command. This command runs a start script that determines if the servera machine is reachable on the network. It also prepares the second disk on servera for the exercise.

```
[student@workstation ~]$ lab storage-partitions start
```

1. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication, therefore a password is not required.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Use the sudo -i command to switch to the root user. If prompted, use student as the password.

```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

3. Use parted to create a new disk label of type msdos on the /dev/vdb disk to prepare that new disk for the MBR partitioning scheme.

```
[root@servera ~]# parted /dev/vdb mklabel msdos
Information: You may need to update /etc/fstab.
```

4. Add a new primary partition that is 1 GB in size. For proper alignment, start the partition at the sector 2048. Set the partition file system type to XFS.

4.1. Use parted interactive mode to help you create the partition.

```
[root@servera ~]# parted /dev/vdb
GNU Parted 3.2
Using /dev/vdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) mkpart
Partition type?  primary/extended? primary
File system type?  [ext2]? xfs
Start? 2048s
End? 1001MB
(parted) quit
Information: You may need to update /etc/fstab.
```

Because the partition starts at the sector 2048, the previous command sets the end position to 1001MB to get a partition size of 1000MB (1 GB).

As an alternative, you can perform the same operation with the following noninteractive command: parted /dev/vdb mkpart primary xfs 2048s 1001MB

4.2. Verify your work by listing the partitions on /dev/vdb.

```
[root@servera ~]# parted /dev/vdb print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  1001MB  1000MB  primary
```

4.3. Run the udevadm settle command. This command waits for the system to register the new partition and returns when it is done.

```
[root@servera ~]# udevadm settle
```

5. Format the new partition with the XFS file system.

```
[root@servera ~]# mkfs.xfs /dev/vdb1
meta-data=/dev/vdb1              isize=512    agcount=4, agsize=61056 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=244224, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=1566, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```

6. Configure the new file system to mount at /archive persistently.

6.1. Use mkdir to create the /archive directory mount point.

```
[root@servera ~]# mkdir /archive
```

6.2. Use the lsblk command with the --fs option to discover the UUID of the /dev/vdb1 device.

```
[root@servera ~]# lsblk --fs /dev/vdb
NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
vdb
└─vdb1 xfs          e3db1abe-6d96-4faa-a213-b96a6f85dcc1
```

The UUID in the previous output is probably different on your system.

6.3. Add an entry to /etc/fstab. In the following content, replace the UUID with the one you discovered from the previous step.

```
...output omitted...
UUID=e3db1abe-6d96-4faa-a213-b96a6f85dcc1 /archive xfs defaults  0 0
```

6.4. Update systemd for the system to register the new /etc/fstab configuration.

```
[root@servera ~]# systemctl daemon-reload
```

6.5. Execute the mount /archive command to mount the new file system using the new entry added to /etc/fstab.

```
[root@servera ~]# mount /archive
```

6.6. Verify that the new file system is mounted at /archive.

```
[root@servera ~]# mount | grep /archive
/dev/vdb1 on /archive type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
```

7. Reboot servera. After the server has rebooted, log in and verify that /dev/vdb1 is mounted at /archive. When done, log off from servera.

7.1. Reboot servera.

```
[root@servera ~]# systemctl reboot
Connection to servera closed by remote host.
Connection to servera closed.
[student@workstation ~]$ 
```

7.2. Wait a few minutes for servera to reboot and log in as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

7.3. Verify that /dev/vdb1 is mounted at /archive.

```
[student@servera ~]$ mount | grep /archive
/dev/vdb1 on /archive type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
```

7.4. Log off from servera.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab storage-partitions finish script to complete this exercise.

```
[student@workstation ~]$ lab storage-partitions finish
```

This concludes the guided exercise.

