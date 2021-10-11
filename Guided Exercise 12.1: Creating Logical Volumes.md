# Guided Exercise 12.1: Creating Logical Volumes

In this lab, you will create a physical volume, volume group, logical volume, and an XFS file system. You will also persistently mount the logical volume file system.

## Outcomes

You should be able to:

- Create physical volumes, volume groups, and logical volumes with LVM tools.

- Create new file systems on logical volumes and persistently mount them.

Log in as the student user on workstation using student as the password.

On workstation, run the lab lvm-creating start command. This command runs a start script that determines if the servera machine is reachable on the network. It also verifies that storage is available and that the appropriate software packages are installed.
```
[student@workstation ~]$ lab lvm-creating start
```

1. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication, therefore a password is not required.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$
```

2. Use the sudo -i command to switch to the root user. The password for the student user is student.
```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

3. Create the physical resources on the /dev/vdb device.

3.1. Use parted to create two 256 MiB partitions and set them to type Linux LVM.
```
[root@servera ~]# parted -s /dev/vdb mklabel gpt
[root@servera ~]# parted -s /dev/vdb mkpart primary 1MiB 257MiB
[root@servera ~]# parted -s /dev/vdb set 1 lvm on
[root@servera ~]# parted -s /dev/vdb mkpart primary 258MiB 514MiB
[root@servera ~]# parted -s /dev/vdb set 2 lvm on
```

3.2 Use udevadm settle for the system to register the new partitions.
```
[root@servera ~]# udevadm settle
```

4. Use pvcreate to add the two new partitions as PVs.
```
[root@servera ~]# pvcreate /dev/vdb1 /dev/vdb2
  Physical volume "/dev/vdb1" successfully created.
  Physical volume "/dev/vdb2" successfully created.
```

5. Use vgcreate to create a new VG named servera_01_vg built from the two PVs.
```
[root@servera ~]# vgcreate servera_01_vg /dev/vdb1 /dev/vdb2
  Volume group "servera_01_vg" successfully created
```

6. Use lvcreate to create a 400 MiB LV named servera_01_lv from the servera_01_vg VG.
```
[root@servera ~]# lvcreate -n servera_01_lv -L 400M servera_01_vg
  Logical volume "servera_01_lv" created.
```

This creates a device named /dev/servera_01_vg/servera_01_lv but without a file system on it.

7. Add a persistent file system.

7.1. Add an XFS file system on the servera_01_lv LV with the mkfs command.
```
[root@servera ~]# mkfs -t xfs /dev/servera_01_vg/servera_01_lv
...output omitted...
```

7.2. Create a mount point at /data.
```
[root@servera ~]# mkdir /data
```

7.3. Add the following line to the end of /etc/fstab on servera:
```
/dev/servera_01_vg/servera_01_lv    /data    xfs  defaults  1 2
```

7.4. Use systemctl daemon-reload to update systemd with the new /etc/fstab configuration.
```
[root@servera ~]# systemctl daemon-reload
```

7.5. Verify the /etc/fstab entry and mount the new servera_01_lv LV device with the mount command.
```
[root@servera ~]# mount /data
```

8. Test and review your work.

8.1 As a final test, copy some files to /data and verify how many were copied.
```
[root@servera ~]# cp -a /etc/*.conf /data
[root@servera ~]# ls /data | wc -l
34

```

8.2. You will verify that you still have the same number of files in the next guided exercise.

parted /dev/vdb print lists the partitions that exist on /dev/vdb.
```
[root@servera ~]# parted /dev/vdb print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 5369MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End    Size   File system  Name     Flags
 1      1049kB  269MB  268MB               primary  lvm
 2      271MB   539MB  268MB               primary  lvm
```

Notice the Number column, which contains the values 1 and 2. These correspond to /dev/vdb1 and /dev/vdb2, respectively. Also notice the Flags column, which indicates the partition type.

8.3. pvdisplay displays information about each of the physical volumes. Optionally, include the device name to limit details to a specific PV.
```
[root@servera ~]# pvdisplay /dev/vdb2
  --- Physical volume ---
  PV Name               /dev/vdb2
  VG Name               servera_01_vg
  PV Size               256.00 MiB / not usable 4.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              63
  Free PE               26
  Allocated PE          37
  PV UUID               2z0Cf3-99YI-w9ny-alEW-wWhL-S8RJ-M2rfZk
```

This shows that the PV is allocated to VG servera_01_vg, is 256 MiB in size (although 4 MiB is not usable), and the physical extent size (PE Size) is 4 MiB (the smallest allocatable LV size).

There are 63 PEs, of which 26 are free for allocation to LVs in the future and 37 are currently allocated to LVs. These translate to MiB values as follows:

- Total 252 MiB (63 PEs x 4 MiB); remember, 4 MiB is unusable.

- Free 104 MiB (26 PEs x 4 MiB)

- Allocated 148 MiB (37 PEs x 4 MiB)

8.4. vgdisplay vgname shows information about the volume group named vgname.
```
[root@servera ~]# vgdisplay servera_01_vg
```

Verify the following values:

- VG Size is 504.00MiB.

- Total PE is 126.

- Alloc PE / Size is 100 / 400.00MiB.

- Free PE / Size is 26 / 104.00MiB.

8.5. lvdisplay /dev/vgname/lvname displays information about the logical volume named lvname.
```
[root@servera ~]# lvdisplay /dev/servera_01_vg/servera_01_lv
```

Review the LV Path, LV Name, VG Name, LV Status, LV Size, and Current LE (logical extents, which map to physical extents).

8.6. The mount command shows all mounted devices and any mount options. It should include /dev/servera_01_vg/servera_01_lv.

NOTE
Many tools report the device mapper name instead, /dev/mapper/servera_01_vg-servera_01_lv; it is the same logical volume.
```
[root@servera ~]# mount
```

You should see (probably on the last line) /dev/mapper/servera_01_vg-servera_01_lv mounted on /data and the associated mount information.

8.7. df -h displays human-readable disk free space. Optionally, include the mount point to limit details to that file system.
```
[root@servera ~]# df -h /data
Filesystem                                 Size  Used Avail Use% Mounted on
/dev/mapper/servera_01_vg-servera_01_lv  395M   24M  372M   6% /data 
```

Allowing for file-system metadata, these values are expected.

9. Log off from servera.
```
[root@servera ~]# exit
logout
[student@servera ~]$ exit 
logout
Connection to servera closed.
[student@workstation ~]$
```

## Finish

On workstation, run the lab lvm-creating finish script to finish this exercise. This script removes the storage configured on servera during the exercise.
```
[student@workstation ~]$ lab lvm-creating finish
```

This concludes the guided exercise.

