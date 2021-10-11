# Guided Exercise 14.3 Lab: Accessing Network-Attached Storage

## Performance Checklist

In this lab, you will set up the automounter with an indirect map, using shares from an NFSv4 server.

Outcomes

You should be able to:

- Install required packages needed to set up the automounter.

- Configure an automounter indirect map, getting resources from a preconfigured NFSv4 server.

Log in to workstation as student using student as the password.

On workstation, run the lab netstorage-review start command. This start script determines if the servera and serverb systems are reachable on the network. The start script configures serverb as an NFSv4 server, sets up permissions, and exports directories. It also creates users and groups needed on both servera and serverb systems.
```
[student@workstation ~]$ lab netstorage-review start
```
An IT support company uses a central server, serverb, to host some shared directories on /remote/shares for their groups and users. Users need to be able to log in and have their shared directories mounted on demand and ready to use, under the /shares directory on servera.

Important information:

- serverb is sharing the /shares directory, which in turn contains the management, production and operation subdirectories.

- The managers group consists of the manager1 and manager2 users. They have read and write access to the /shares/management shared directory.

- The production group consists of the dbuser1 and sysadmin1 users. They have read and write access to the /shares/production shared directory.

- The operators group consists of the contractor1 and consultant1 users. They have read and write access to the /shares/operation shared directory.

- The main mount point for servera is the /remote directory.

- The /shares/management shared directory should be automounted on /remote/management on servera.

- The /shares/production shared directory should be automounted on /remote/production on servera.

- The /shares/operation shared directory should be automounted on /remote/operation on servera.

- All user passwords are set to redhat.

1. Log in to servera and install the required packages.

1.1. Log in to servera as the student user.
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

1.3. Install the autofs package.
```
[root@servera ~]# yum install autofs
...output omitted...
Is this ok [y/N]: y
...output omitted...
```

2. Configure an automounter indirect map on servera using shares from serverb. Create an indirect map using files named /etc/auto.master.d/shares.autofs for the master map and /etc/auto.shares for the mapping file. Use the /remote directory as the main mount point on servera. Reboot servera to determine if the autofs service starts automatically.

2.1. Test the NFS server before proceeding to configure the automounter.
```
[root@servera ~]# mount -t nfs serverb.lab.example.com:/shares /mnt
[root@servera ~]# ls -l /mnt
total 0
drwxrwx---. 2 root managers   25 Apr  4 01:13 management
drwxrwx---. 2 root operators  25 Apr  4 01:13 operation
drwxrwx---. 2 root production 25 Apr  4 01:13 production
[root@servera ~]# umount /mnt
```

2.2. Create a master map file named /etc/auto.master.d/shares.autofs, insert the following content, and save the changes.
```
[root@servera ~]# vim /etc/auto.master.d/shares.autofs
/remote	/etc/auto.shares
```

2.3. Create an indirect map file named /etc/auto.shares, insert the following content, and save the changes.
```
[root@servera ~]# vim /etc/auto.shares
*	-rw,sync,fstype=nfs4	serverb.lab.example.com:/shares/&
```

2.4. Start and enable the autofs service on servera.
```
[root@servera ~]# systemctl enable --now autofs
```

2.5. Created symlink /etc/systemd/system/multi-user.target.wants/autofs.service → /usr/lib/systemd/system/autofs.service.
Reboot theservera machine.
```
[root@servera ~]# systemctl reboot
```

3. Test the autofs configuration with the various users. When done, log off from servera.

3.1. After the servera machine has finished booting, log in to servera as the student user.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

3.2. Use the su - manager1 command to switch to the manager1 user and test access.
```
[student@servera ~]$ su - manager1
Password: redhat
[manager1@servera ~]$ ls -l /remote/management/
total 4
-rw-r--r--. 1 root managers 46 Apr  4 01:13 Welcome.txt
[manager1@servera ~]$ cat /remote/management/Welcome.txt
###Welcome to Management Folder on SERVERB###
[manager1@servera ~]$ echo TEST1 > /remote/management/Test.txt
[manager1@servera ~]$ cat /remote/management/Test.txt
TEST1
[manager1@servera ~]$ ls -l /remote/operation/
ls: cannot open directory '/remote/operation/': Permission denied
[manager1@servera ~]$ ls -l /remote/production/
ls: cannot open directory '/remote/production/': Permission denied
[manager1@servera ~]$ exit
logout
[student@servera ~]$ 
```

3.3. Switch to the dbuser1 user and test access.
```
[student@servera ~]$ su - dbuser1
Password: redhat
[dbuser1@servera ~]$ ls -l /remote/production/
total 4
-rw-r--r--. 1 root production 46 Apr  4 01:13 Welcome.txt
[dbuser1@servera ~]$ cat /remote/production/Welcome.txt
###Welcome to Production Folder on SERVERB###
[dbuser1@servera ~]$ echo TEST2 > /remote/production/Test.txt
[dbuser1@servera ~]$ cat /remote/production/Test.txt
TEST2
[dbuser1@servera ~]$ ls -l /remote/operation/
ls: cannot open directory '/remote/operation/': Permission denied
[dbuser1@servera ~]$ ls -l /remote/management/
ls: cannot open directory '/remote/management/': Permission denied
[dbuser1@servera ~]$ exit
logout
[student@servera ~]$ 
```

3.4. Switch to the contractor1 user and test access.
```
[student@servera ~]$ su - contractor1
Password: redhat
[contractor1@servera ~]$ ls -l /remote/operation/
total 4
-rw-r--r--. 1 root operators 45 Apr  4 01:13 Welcome.txt
[contractor1@servera ~]$ cat /remote/operation/Welcome.txt
###Welcome to Operation Folder on SERVERB###
[contractor1@servera ~]$ echo TEST3 > /remote/operation/Test.txt
[contractor1@servera ~]$ cat /remote/operation/Test.txt
TEST3
[contractor1@servera ~]$ ls -l /remote/management/
ls: cannot open directory '/remote/management/': Permission denied
[contractor1@servera ~]$ ls -l /remote/production/
ls: cannot open directory '/remote/production/': Permission denied
[contractor1@servera ~]$ exit
logout
[student@servera ~]$ 
```

3.5. Explore the mount options for the NFS automounted share.
```
[student@servera ~]$ mount | grep nfs
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
serverb.lab.example.com:/shares/management on /remote/management type nfs4
(rw,relatime,vers=4.2,rsize=262144,wsize=262144,namlen=255,
sync,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=172.25.250.10,
local_lock=none,addr=172.25.250.11)
serverb.lab.example.com:/shares/operation on /remote/operation type nfs4
(rw,relatime,vers=4.2,rsize=262144,wsize=262144,namlen=255,
sync,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=172.25.250.10,
local_lock=none,addr=172.25.250.11)
serverb.lab.example.com:/shares/production on /remote/production type nfs4
(rw,relatime,vers=4.2,rsize=262144,wsize=262144,namlen=255,
sync,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=172.25.250.10,
local_lock=none,addr=172.25.250.11)
```

3.6. Log off from servera.
```
[student@servera ~]$ exit
logout
[student@workstation ~]$ 
```

## Evaluation

On workstation, run the lab netstorage-review grade command to confirm success of this exercise.
```
[student@workstation ~]$ lab netstorage-review grade
```

## Finish

On workstation, run the lab netstorage-review finish command to complete this exercise.
```
[student@workstation ~]$ lab netstorage-review finish
```

This concludes the lab.