# Guided Exercise 8.3: Managing Swap Space

In this exercise, you will create and format a partition for use as swap space, format it as swap, and activate it persistently.

## Outcomes

You should be able to create a partition and a swap space on a disk using the GPT partitioning scheme.

Log in as the student user on workstation using student as the password.

On workstation, run the lab storage-swap start command. This command runs a start script that determines if the servera machine is reachable on the network. It also prepares the second disk on servera for the exercise.

```
[student@workstation ~]$ lab storage-swap start
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

3. Use the parted command to inspect the /dev/vdb disk.

```
[root@servera ~]# parted /dev/vdb print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  1001MB  1000MB               data
```

Notice that the disk already has a partition table and uses the GPT partitioning scheme. Also, a 1 GB partition already exists.

4. Add a new partition that is 500 MB in size for use as swap space. Set the partition type to linux-swap.

4.1 Use parted to create the partition. Because the disk uses the GPT partitioning scheme, you need to give a name to the partition. Call it myswap.

```
[root@servera ~]# parted /dev/vdb mkpart myswap linux-swap \
1001MB 1501MB
Information: You may need to update /etc/fstab.
```

Notice in the previous command that the start position, 1001 MB, is the end of the existing first partition. This way parted makes sure that the new partition immediately follows the previous one, without any gap.

Because the partition starts at the 1001 MB position, the command sets the end position to 1501 MB to get a partition size of 500 MB.

4.2. Verify your work by listing the partitions on /dev/vdb.

```
[root@servera ~]# parted /dev/vdb print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name   Flags
 1      1049kB  1001MB  1000MB               data
 2      1001MB  1501MB  499MB                myswap swap
```

The size of the new partition is not exactly 500 MB. This is because parted has to align the partition with the disk layout.

4.3. Run the udevadm settle command. This command waits for the system to register the new partition and returns when it is done.

```
[root@servera ~]# udevadm settle
```

5. Initialize the newly created partition as swap space.

```
[root@servera ~]# mkswap /dev/vdb2
Setting up swapspace version 1, size = 476 MiB (499118080 bytes)
no label, UUID=cb7f71ca-ee82-430e-ad4b-7dda12632328
```

6. Enable the newly created swap space.

6.1. Use the swapon --show command to show that creating and initializing swap space does not yet enable it for use.

```
[root@servera ~]# swapon --show
```

6.2. Enable the newly created swap space.

```
[root@servera ~]# swapon /dev/vdb2
```

6.3. Verify that the newly created swap space is now available.

```
[root@servera ~]# swapon --show
NAME      TYPE      SIZE USED PRIO
/dev/vdb2 partition 476M   0B   -2
```

6.4. Disable the swap space.

```
[root@servera ~]# swapoff /dev/vdb2
```

6.5. Confirm that the swap space is disabled.

```
[root@servera ~]# swapon --show
```

7. Configure the new swap space to be enabled at system boot.

7.1. Use the lsblk command with the --fs option to discover the UUID of the /dev/vdb2 device.

```
[root@servera ~]# lsblk --fs /dev/vdb2
NAME FSTYPE LABEL UUID                                 MOUNTPOINT
vdb2 swap         cb7f71ca-ee82-430e-ad4b-7dda12632328
```

The UUID in the previous output is probably different on your system.

7.2 Add an entry to /etc/fstab. In the following command, replace the UUID with the one you discovered from the previous step.

```
...output omitted...
UUID=cb7f71ca-ee82-430e-ad4b-7dda12632328  swap  swap  defaults  0 0
```

7.3. Update systemd for the system to register the new /etc/fstab configuration.

```
[root@servera ~]# systemctl daemon-reload
```

7.4. Enable the swap space using the entry just added to /etc/fstab.

```
[root@servera ~]# swapon -a
```

7.5. Verify that the new swap space is enabled.

```
[root@servera ~]# swapon --show
NAME      TYPE      SIZE USED PRIO
/dev/vdb2 partition 476M   0B   -2
```

8. Reboot servera. After the server has rebooted, log in and verify that the swap space is enabled. When done, log off from servera.

8.1. Reboot servera.

```
[root@servera ~]# systemctl reboot
Connection to servera closed by remote host.
Connection to servera closed.
[student@workstation ~]$ 
```

8.2. Wait a few minutes for servera to reboot and log in as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

8.3. Verify that the swap space is enabled.

```
[root@servera ~]# swapon --show
NAME      TYPE      SIZE USED PRIO
/dev/vdb2 partition 476M   0B   -2
```

8.4. Log off from servera.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab storage-swap finish script to complete this exercise.

```
[student@workstation ~]$ lab storage-swap finish
```

This concludes the guided exercise.

