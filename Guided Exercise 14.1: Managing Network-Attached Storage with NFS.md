# Guided Exercise 14.1: Managing Network-Attached Storage with NFS

## Performance Checklist

In this exercise, you will modify the /etc/fstab file to persistently mount an NFS export at boot time.

## Outcomes

You should be able to:

- Test an NFS Server using the mount command.

- Configure NFS Shares in the /etc/fstab configuration file to save changes even after a system reboots.

Log in to workstation as student using student as the password.

On workstation, run the lab netstorage-nfs start command. This command runs a start script that determines if the servera and serverb machines are reachable on the network. The script will alert you if they are not available. The start script configures serverb as an NFSv4 Server, sets up permissions, and exports directories. It creates users and groups needed on both servera and serverb.
```
[student@workstation ~]$ lab netstorage-nfs start
```

A shipping company uses a central server, serverb, to host a number of shared documents and directories. Users on servera, who are all members of the admin group, need access to the persistently mounted NFS share.

Important information:

- serverb shares the /shares/public directory, which contains some text files.

- Members of the admin group (admin1, sysmanager1) have read and write access to the /shares/public shared directory.

- The principle mount point for servera is /public.

- All user passwords are set to redhat.

1. Log in to servera as the student user and switch to the root user.

1.1 Log in to servera as the student user.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

1.2. Use the sudo -i command to switch to the root user. The password for the student user is student.
```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

2. Test the NFS server on serverb using servera as the NFS client.

2.1. Create the mount point /public on servera.
```
[root@servera ~]# mkdir /public
```

2.2. On servera, use the mount command to verify that the /share/public NFS share exported by serverb mounts correctly on the /public mount point.
```
[root@servera ~]# mount -t nfs \
serverb.lab.example.com:/shares/public /public
```

2.3. List the contents of the mounted NFS share.
```
[root@servera ~]# ls -l /public
total 16
-rw-r--r--. 1 root admin 42 Apr  8 22:36 Delivered.txt
-rw-r--r--. 1 root admin 46 Apr  8 22:36 NOTES.txt
-rw-r--r--. 1 root admin 20 Apr  8 22:36 README.txt
-rw-r--r--. 1 root admin 27 Apr  8 22:36 Trackings.txt
```

2.4. Explore the mount command options for the NFS mounted share.
```
[root@servera ~]# mount | grep public
serverb.lab.example.com:/shares/public on /public type nfs4
(rw,relatime,vers=4.2,rsize=262144,wsize=262144,namlen=255,sync
,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=172.25.250.10,
local_lock=none,addr=172.25.250.11)
```

2.5. Unmount the NFS share.
```
[root@servera ~]# umount /public
```

3. Configure servera to ensure that the share used above is persistently mounted.

3.1. Open the /etc/fstab file for editing.
```
[root@servera ~]# vim /etc/fstab
```

Add the following line to the end of the file:
```
serverb.lab.example.com:/shares/public  /public  nfs  rw,sync  0 0
```

3.2. Use the mount command to mount the shared directory.
```
[root@servera ~]# mount /public
```

3.3. List the contents of the shared directory.
```
[root@servera ~]# ls -l /public
total 16
-rw-r--r--. 1 root   admin 42 Apr  8 22:36 Delivered.txt
-rw-r--r--. 1 root   admin 46 Apr  8 22:36 NOTES.txt
-rw-r--r--. 1 root   admin 20 Apr  8 22:36 README.txt
-rw-r--r--. 1 root   admin 27 Apr  8 22:36 Trackings.txt
```

3.4. Reboot the servera machine.
```
[root@servera ~]# systemctl reboot
```

4. After servera has finished rebooting, log in to servera as the admin1 user and test the persistently mounted NFS share.

4.1. Log in to servera as the admin1 user.
```
[student@workstation ~]$ ssh admin1@servera
[admin1@servera ~]$ 
```

4.2. Test the NFS share mounted on /public
```
[admin1@servera ~]$ ls -l /public
total 16
-rw-r--r--. 1 root   admin 42 Apr  8 22:36 Delivered.txt
-rw-r--r--. 1 root   admin 46 Apr  8 22:36 NOTES.txt
-rw-r--r--. 1 root   admin 20 Apr  8 22:36 README.txt
-rw-r--r--. 1 root   admin 27 Apr  8 22:36 Trackings.txt
[admin1@servera ~]$ cat /public/NOTES.txt
###In this file you can log all your notes###
[admin1@servera ~]$ echo "This is a test" > /public/Test.txt
[admin1@servera ~]$ cat /public/Test.txt
This is a test
```

4.3. Log off from servera.
```
[admin1@servera ~]$ exit
logout
Connection to servera closed.
```

## Finish

On workstation, run the lab netstorage-nfs finish script to complete this exercise.
```
[student@workstation ~]$ lab netstorage-nfs finish
```

This concludes the guided exercise.

