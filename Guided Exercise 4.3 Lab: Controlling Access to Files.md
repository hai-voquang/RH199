# Guided Exercise 4.3 Lab: Controlling Access to Files

## Performance Checklist

In this lab, you will configure permissions on files and set up a directory that users in a particular group can use to conveniently share files on the local file system.

## Outcomes

You should be able to:

- Create a directory where users can work collaboratively on files.

- Create files that are automatically assigned group ownership.

- Create files that are not accessible outside of the group.

Log in to workstation as student using student as the password.

On workstation, run the lab perms-review start command. The command runs a start script that determines if serverb is reachable on the network. The script also creates the techdocs group and three users named tech1, tech2, and database1.

```
[student@workstation ~]$ lab perms-review start
```

1. Use the ssh command to log in to serverb as the student user. Switch to root on serverb using redhat as the password.

```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ su -
Password: redhat
[root@serverb ~]# 
```

2. Create a directory called /home/techdocs.

2.1. Use the mkdir command to create a directory called /home/techdocs.

```
[root@serverb ~]# mkdir /home/techdocs
```

3. Change the group ownership of the /home/techdocs directory to the techdocs group.

3.1. Use the chown command to change the group ownership for the /home/techdocs directory to the techdocs group.

```
[root@serverb ~]# chown :techdocs /home/techdocs
```

4. Verify that users in the techdocs group cannot currently create files in the /home/techdocs directory.

4.1. Use the su command to switch to the tech1 user.

```
[root@serverb ~]# su - tech1
[tech1@serverb ~]$ 
```

4.2. Use touch to create a file named techdoc1.txt in the /home/techdocs directory.

```
[tech1@serverb ~]$ touch /home/techdocs/techdoc1.txt
touch: cannot touch '/home/techdocs/techdoc1.txt': Permission denied
```

NOTE
Note that even though the /home/techdocs directory is owned by techdocs and tech1 is part of the techdocs group, it is not possible to create a new file in that directory. This is because the techdocs group does not have write permission. Use the ls -ld command to show the permissions.

```
[tech1@serverb ~]$ ls -ld /home/techdocs/
  drwxr-xr-x. 2 root techdocs 6 Feb  5 16:05 /home/techdocs/
```

5. Set permissions on the /home/techdocs directory. On the /home/techdocs directory, configure setgid (2), read/write/execute permissions (7) for the owner/user and group, and no permissions (0) for other users.

5.1. Exit from the tech1 user shell.

```
[tech1@serverb ~]$ exit
logout
[root@serverb ~]# 
```

5.2. Use the chmod command to set the group permission for the /home/techdocs directory. On the /home/techdocs directory, configure setgid (2), read/write/execute permissions (7) for the owner/user and group, and no permissions (0) for other users.

```
[root@serverb ~]# chmod 2770 /home/techdocs
```

6. Verify that the permissions are set properly.

```
[root@serverb ~]# ls -ld /home/techdocs
drwxrws---. 2 root techdocs 6 Feb 4 18:12 /home/techdocs/ 
```

Note that the techdocs group now has write permission.

7. Confirm that users in the techdocs group can now create and edit files in the /home/techdocs directory. Users not in the techdocs group cannot edit or create files in the /home/techdocs directory. Users tech1 and tech2 are in the techdocs group. User database1 is not in that group.

7.1. Switch to the tech1 user. Use touch to create a file called techdoc1.txt in the /home/techdocs directory. Exit from the tech1 user shell.

```
[root@serverb ~]# su - tech1
[tech1@serverb ~]$ touch /home/techdocs/techdoc1.txt
[tech1@serverb ~]$ ls -l /home/techdocs/techdoc1.txt
-rw-rw-r--. 1 tech1 techdocs 0 Feb  5 16:42 /home/techdocs/techdoc1.txt
[tech1@serverb ~]$ exit
logout
[root@serverb ~]# 
```

7.2. Switch to the tech2 user. Use the echo command to add some content to the /home/techdocs/techdoc1.txt file. Exit from the tech2 user shell.

```
[root@serverb ~]# su - tech2
[tech2@serverb ~]$ cd /home/techdocs
[tech2@serverb techdocs]$ echo "This is the first tech doc." > techdoc1.txt
[tech2@serverb techdocs]$ exit
logout
[root@serverb ~]# 
```

7.3. Switch to the database1 user. Use the echo command to append some content to the /home/techdocs/techdoc1.txt file. Notice that you will get a Permission Denied message. Use the ls -l command to confirm that database1 does not have access to the file. Exit from the database1 user shell.

The following echo command is very long and should be entered on a single line.

```
[root@serverb ~]# su - database1
[database1@serverb ~]$ echo "This is the first tech doc." >> /home/techdocs/techdoc1.txt
-bash: /home/techdocs/techdoc1.txt: Permission denied
[database1@serverb ~]$ ls -l /home/techdocs/techdoc1.txt
ls: cannot access '/home/techdocs/techdoc1.txt': Permission denied
[database1@serverb ~]$ exit
logout
[root@serverb ~]# 
```

8. Modify the global login scripts. Normal users should have a umask setting that prevents others from viewing or modifying new files and directories.

8.1 Determine the umask of the student user. Use the su - student command to switch to student login shell. When done exit from the shell.

```
[root@serverb ~]# su - student
[student@serverb ~]$ umask
0002
[student@serverb ~]$ exit
logout
[root@serverb ~]# 
```

8.2. Create the /etc/profile.d/local-umask.sh file with the following content to set the umask to 007 for users with a UID greater than 199 and with a username and primary group name that match, and to 022 for everyone else:

```
# Overrides default umask configuration
if [ $UID -gt 199 ] && [ "`id -gn`" = "`id -un`" ]; then
    umask 007
else
    umask 022
fi
```

8.3. Log out of the shell and log back in as student to verify that global umask changes to 007.

```
[root@serverb ~]# exit
logout
[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ umask
0007
```

9. Log off from serverb.

```
[student@serverb ~]$ exit
logout
Connection to serverb closed.
```

## Evaluation

On workstation, run the lab perms-review grade script to confirm success on this exercise.

```
[student@workstation ~]$ lab perms-review grade
```

## Finish

On workstation, run the lab perms-review finish script to complete the lab.

```
[student@workstation ~]$ lab perms-review finish
```

This concludes the lab.
