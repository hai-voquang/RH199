# Guided Exercise 12.2: Extending Logical Volumes

In this lab, you will extend the logical volume added in the previous practice exercise.

## Outcomes

You should be able to:

- Extend the volume group to include an additional physical volume.

- Resize the logical volume while the file system is still mounted and in use.

Log in as the student user on workstation using student as the password.

On workstation, run the lab lvm-extending start command. This command runs a start script that determines if the host servera is reachable on the network and ensures that the storage from the previous guided exercise is available.
```
[student@workstation ~]$ lab lvm-extending start
```

1. Use the ssh command to log in to servera as the student user.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Use the sudo -i command to switch to root at the shell prompt.
```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

3. Use vgdisplay to determine if the VG has sufficient free space to extend the LV to a total size of 700 MiB.
```
[root@servera ~]# vgdisplay servera_01_vg
  --- Volume group ---
  VG Name               servera_01_vg
  System ID
  Format                lvm2
...output omitted...
  VG Size               504.00 MiB
  PE Size               4.00 MiB
  Total PE              126
  Alloc PE / Size       100 / 400.00 MiB
  Free  PE / Size       26 / 104.00 MiB
  VG UUID               OBBAtU-2nBS-4SW1-khmF-yJzi-z7bD-DpCrAV
```

Only 104 MiB is available (26 PEs x 4 MiB extents) and you need at least 300 MiB to have 700 MiB in total. You need to extend the VG.

For later comparison, use df to record current disk free space:
```
[root@servera ~]# df -h /data
Filesystem                               Size  Used Avail Use% Mounted on
/dev/mapper/servera_01_vg-servera_01_lv  395M   24M  372M   6% /data
```

4. Create the physical resource.

4.1. Use parted to create an additional partition of 512 MiB and set it to type Linux LVM.
```
[root@servera ~]# parted -s /dev/vdb mkpart primary 515MiB 1027MiB
[root@servera ~]# parted -s /dev/vdb set 3 lvm on
```

4.2. Use udevadm settle for the system to register the new partition.
```
[root@servera ~]# udevadm settle
```

5. Use pvcreate to add the new partition as a PV.
```
[root@servera ~]# pvcreate /dev/vdb3
  Physical volume "/dev/vdb3" successfully created.
```

6. Extend the volume group.

6.1. Use vgextend to extend the VG named servera_01_vg, using the new /dev/vdb3 PV.
```
[root@servera ~]# vgextend servera_01_vg /dev/vdb3
  Volume group "servera_01_vg" successfully extended
```

6.2. Use vgdisplay to inspect the servera_01_vg VG free space again. There should be plenty of free space now.
```
[root@servera ~]# vgdisplay servera_01_vg
  --- Volume group ---
  VG Name               servera_01_vg
  System ID
  Format                lvm2
...output omitted...
  VG Size               1012.00 MiB
  PE Size               4.00 MiB
  Total PE              253
  Alloc PE / Size       100 / 400.00 MiB
  Free  PE / Size       153 / 612.00 MiB
  VG UUID               OBBAtU-2nBS-4SW1-khmF-yJzi-z7bD-DpCrAV
```

612 MiB of free space is now available (153 PEs x 4 MiB extents).

7. Use lvextend to extend the existing LV to 700 MiB.
```
[root@servera ~]# lvextend -L 700M /dev/servera_01_vg/servera_01_lv
  Size of logical volume servera_01_vg/servera_01_lv changed from 400.00 MiB (100 extents) to 700.00 MiB (175 extents).
    Logical volume servera_01_vg/servera_01_lv successfully resized.
```

NOTE
The example specifies the exact size to make the final LV, but you could have specified the amount of additional space desired:

- -L +300M to add the new space using size in MiB.

- -l 175 to specify the total number of extents (175 PEs x 4 MiB).

- -l +75 to add the additional extents needed.

8. Use xfs_growfs to extend the XFS file system to the remainder of the free space on the LV.
```
[root@servera ~]# xfs_growfs /data
meta-data=/dev/mapper/servera_01_vg-servera_01_lv isize=512    agcount=4, agsize=25600 blks
...output omitted...
```

9. Use df and ls | wc to review the new file-system size and verify that the previously existing files are still present.
```
[root@servera ~]# df -h /data
Filesystem                               Size  Used Avail Use% Mounted on
/dev/mapper/servera_01_vg-servera_01_lv  695M   26M  670M   4% /data
[root@servera ~]# ls /data | wc -l
34
```

The files still exist and the file system approximates the specified size.

10. Log off from servera.
```
[root@servera ~]# exit
logout
[student@servera ~]$ exit 
logout
Connection to servera closed.
[student@workstation ~]$
```

## Finish

On workstation, run the lab lvm-extending finish command to finish this exercise. This script removes the storage configured on servera during the exercise.
```
[student@workstation ~]$ lab lvm-extending finish
```

This concludes the guided exercise.

