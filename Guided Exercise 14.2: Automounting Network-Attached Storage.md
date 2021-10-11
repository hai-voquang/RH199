# Guided Exercise 14.2: Automounting Network-Attached Storage

## Performance Checklist

In this exercise, you will create direct mapped and indirect mapped automount-managed mount points that mount NFS file systems.

## Outcomes

You should be able to:

- Install required packages needed for the automounter.

- Configure direct and indirect automounter maps, getting resources from a preconfigured NFSv4 server.

- Understand the difference between direct and indirect automounter maps.

Log in to workstation as student using student as the password.

On workstation, run the lab netstorage-autofs start command. This start script determines if servera and serverb are reachable on the network. The script will alert you if they are not available. The start script configures serverb as an NFSv4 server, sets up permissions, and exports directories. It also creates users and groups needed on both servera and serverb.
```
[student@workstation ~]$ lab netstorage-autofs start
```

An internet service provider uses a central server, serverb, to host shared directories containing important documents that need to be available on demand. When users log in to servera they need access to the automounted shared directories.

Important information:

- serverb is exporting as an NFS share the /shares/indirect directory, which in turn contains the west, central, and east subdirectories.

- serverb is also exporting as an NFS share the /shares/direct/external directory.

- The operators group consists of the operator1 and operator2 users. They have read and write access to the shared directories /shares/indirect/west, /shares/indirect/central, and /shares/indirect/east.

- The contractors group consists of the contractor1 and contractor2 users. They have read and write access to the /shares/direct/external shared directory.

- The expected mount points for servera are /external and /internal.

- The /shares/direct/external shared directory should be automounted on servera using a direct map on /external.

- The /shares/indirect/west shared directory should be automounted on servera using an indirect map on /internal/west.

- The /shares/indirect/central shared directory should be automounted on servera using an indirect map on /internal/central.

- The /shares/indirect/east shared directory should be automounted on servera using an indirect map on /internal/east.

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

2. Configure an automounter direct map on servera using shares from serverb. Create the direct map using files named /etc/auto.master.d/direct.autofs for the master map and /etc/auto.direct for the mapping file. Use the /external directory as the main mount point on servera.

2.1. Test the NFS server and share before proceeding to configure the automounter.
```
[root@servera ~]# mount -t nfs \
serverb.lab.example.com:/shares/direct/external /mnt
[root@servera ~]# ls -l /mnt
total 4
-rw-r--r--. 1 root contractors 22 Apr  7 23:15 README.txt
[root@servera ~]# umount /mnt
```

2.2. Create a master map file named /etc/auto.master.d/direct.autofs, insert the following content, and save the changes.
```
/-	/etc/auto.direct
```

2.3. Create a direct map file named /etc/auto.direct, insert the following content, and save the changes.
```
/external	-rw,sync,fstype=nfs4	serverb.lab.example.com:/shares/direct/external
```

3. Configure an automounter indirect map on servera using shares from serverb. Create the indirect map using files named /etc/auto.master.d/indirect.autofs for the master map and /etc/auto.indirect for the mapping file. Use the /internal directory as the main mount point on servera.

3.1. Test the NFS server and share before proceeding to configure the automounter.
```
[root@servera ~]# mount -t nfs \
serverb.lab.example.com:/shares/indirect /mnt
[root@servera ~]# ls -l /mnt
total 0
drwxrws---. 2 root operators 24 Apr  7 23:34 central
drwxrws---. 2 root operators 24 Apr  7 23:34 east
drwxrws---. 2 root operators 24 Apr  7 23:34 west
[root@servera ~]# umount /mnt
```

3.2. Create a master map file named /etc/auto.master.d/indirect.autofs, insert the following content, and save the changes.
```
/internal	/etc/auto.indirect
```

3.3. Create an indirect map file named /etc/auto.indirect, insert the following content, and save the changes.
```
*	-rw,sync,fstype=nfs4	serverb.lab.example.com:/shares/indirect/&
```

4. Start the autofs service on servera and enable it to start automatically at boot time. Reboot servera to determine if the autofs service starts automatically.

4.1. Start and enable the autofs service on servera.
```
[root@servera ~]# systemctl enable --now autofs
Created symlink /etc/systemd/system/multi-user.target.wants/autofs.service → /usr/lib/systemd/system/autofs.service.
```

4.2. Reboot the servera machine.
```
[root@servera ~]# systemctl reboot
```

5. Test the direct automounter map as the contractor1 user. When done, exit from the contractor1 user session on servera.

5.1. After the servera machine has finished booting, log in to servera as the student user.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

5.2. Switch to the contractor1 user.
```
[student@servera ~]$ su - contractor1
Password: redhat
```

5.3. List the /external mount point.
```
[contractor1@servera ~]$ ls -l /external
total 4
-rw-r--r--. 1 root contractors 22 Apr  7 23:34 README.txt
```

5.4. Review the content and test the access to the /external mount point.
```
[contractor1@servera ~]$ cat /external/README.txt
###External Folder###
[contractor1@servera ~]$ echo testing-direct > /external/testing.txt
[contractor1@servera ~]$ cat /external/testing.txt
testing-direct
```

5.5. Exit from the contractor1 user session.
```
[contractor1@servera ~]$ exit
logout
[student@servera ~]$ 
```

6. Test the indirect automounter map as the operator1 user. When done, log off from servera.

6.1. Switch to operator1 user.
```
[student@servera ~]$ su - operator1
Password: redhat
```

6.2. List the /internal mount point.
```
[operator1@servera ~]$ ls -l /internal
total 0
```

NOTE
You will notice that in an automounter indirect map, even if you are in the mapped mount point, you need to call each of the shared subdirectories or files on demand to get access to them. In an automounter direct map, after you open the mapped mount point, you get access to the directories and content configured in the shared directory.

6.3. Test the /internal/west automounter shared directory access.
```
[operator1@servera ~]$ ls -l /internal/west/
total 4
-rw-r--r--. 1 root operators 18 Apr  7 23:34 README.txt
[operator1@servera ~]$ cat /internal/west/README.txt
###West Folder###
[operator1@servera ~]$ echo testing-1 > /internal/west/testing-1.txt
[operator1@servera ~]$ cat /internal/west/testing-1.txt
testing-1
[operator1@servera ~]$ ls -l /internal
total 0
drwxrws---. 2 root operators 24 Apr  7 23:34 west
```

6.4. Test the /internal/central automounter shared directory access.
```
[operator1@servera ~]$ ls -l /internal/central
total 4
-rw-r--r--. 1 root operators 21 Apr  7 23:34 README.txt
[operator1@servera ~]$ cat /internal/central/README.txt
###Central Folder###
[operator1@servera ~]$ echo testing-2 > /internal/central/testing-2.txt
[operator1@servera ~]$ cat /internal/central/testing-2.txt
testing-2
[operator1@servera ~]$ ls -l /internal
total 0
drwxrws---. 2 root operators 24 Apr  7 23:34 central
drwxrws---. 2 root operators 24 Apr  7 23:34 west
```

6.5. Test the /internal/east automounter shared directory access.
```
[operator1@servera ~]$ ls -l /internal/east
total 4
-rw-r--r--. 1 root operators 18 Apr  7 23:34 README.txt
[operator1@servera ~]$ cat /internal/east/README.txt
###East Folder###
[operator1@servera ~]$ echo testing-3 > /internal/east/testing-3.txt
[operator1@servera ~]$ cat /internal/east/testing-3.txt
testing-3
[operator1@servera ~]$ ls -l /internal
total 0
drwxrws---. 2 root operators 24 Apr  7 23:34 central
drwxrws---. 2 root operators 24 Apr  7 23:34 east
drwxrws---. 2 root operators 24 Apr  7 23:34 west
```

6.6. Test the /external automounter shared directory access.
```
[operator1@servera ~]$ ls -l /external
ls: cannot open directory '/external': Permission denied
```

6.7. Log off from servera.
```
[operator1@servera ~]$ exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
```

## Finish

On workstation, run the lab netstorage-autofs finish script to complete this exercise.
```
[student@workstation ~]$ lab netstorage-autofs finish
```

This concludes the guided exercise.