# Guided Exercise 4.1: Managing File System Permissions from the Command Line

In this exercise, you will use file system permissions to create a directory in which all members of a particular group can add and delete files.

## Outcomes

You should be able to create a collaborative directory that is accessible by all members of a particular group.

Log in to workstation as student using student as the password.

On workstation, run the lab perms-cli start command. The start script creates a group called consultants and two users called consultant1 and consultant2.

```
[student@workstation ~]$ lab perms-cli start
```

1. From workstation, use the ssh command to log in to servera as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Switch to the root user using redhat as the password.

```
[student@servera ~]$ su -
Password: redhat
[root@servera ~]# 
```

3. Use the mkdir command to create the /home/consultants directory.

```
[root@servera ~]# mkdir /home/consultants
```

4. Use the chown command to change the group ownership of the consultants directory to consultants.

```
[root@servera ~]# chown :consultants /home/consultants
```

5. Ensure that the permissions of the consultants group allow its group members to create files in, and delete files from the /home/consultants directory. The permissions should forbid others from accessing the files.

5.1 Use the ls command to confirm that the permissions of the consultants group allow its group members to create files in, and delete files from the /home/consultants directory.

```
[root@servera ~]# ls -ld /home/consultants
drwxr-xr-x.  2 root    consultants       6 Feb  1 12:08 /home/consultants
```

Note that the consultants group currently does not have write permission.

5.2. Use the chmod command to add write permission to the consultants group.

```
[root@servera ~]# chmod g+w /home/consultants
[root@servera ~]# ls -ld /home/consultants
drwxrwxr-x. 2 root consultants 6 Feb  1 13:21 /home/consultants 
```

5.3. Use the chmod command to forbid others from accessing files in the /home/consultants directory.

```
[root@servera ~]# chmod 770 /home/consultants
[root@servera ~]# ls -ld /home/consultants
drwxrwx---. 2 root consultants 6 Feb  1 12:08 /home/consultants/
```

6. Exit the root shell and switch to the consultant1 user. The password is redhat.

```
[root@servera ~]# exit
logout
[student@servera ~]$ 
[student@servera ~]$ su - consultant1
Password: redhat
```

7. Navigate to the /home/consultants directory and create a file called consultant1.txt.

7.1 Use the cd command to change to the /home/consultants directory.

```
[consultant1@servera ~]$ cd /home/consultants
```

7.2 Use the touch command to create an empty file called consultant1.txt.

```
[consultant1@servera consultants]$ touch consultant1.txt
```

8. Use the ls -l command to list the default user and group ownership of the new file and its permissions.

```
[consultant1@servera consultants]$ ls -l consultant1.txt
-rw-rw-r--. 1 consultant1 consultant1 0 Feb  1 12:53 consultant1.txt
```

9. Ensure that all members of the consultants group can edit the consultant1.txt file. Change the group ownership of the consultant1.txt file to consultants.

9.1 Use the chown command to change the group ownership of the consultant1.txt file to consultants.

```
[consultant1@servera consultants]$ chown :consultants consultant1.txt
```

9.2 Use the ls command with the -l option to list the new ownership of the consultant1.txt file.

```
[consultant1@servera consultants]$ ls -l consultant1.txt
-rw-rw-r--. 1 consultant1 consultants 0 Feb  1 12:53 consultant1.txt
```

10. Exit the shell and switch to the consultant2 user. The password is redhat.

```
[consultant1@servera consultants]$ exit
logout
[student@servera ~]$ su - consultant2
Password: redhat
[consultant2@servera ~]$ 
```

11. Navigate to the /home/consultants directory. Ensure that the consultant2 user can add content to the consultant1.txt file. Exit from the shell.

11.1. Use the cd command to change to the /home/consultants directory. Use the echo command to add text to the consultant1.txt file.

```
[consultant2@servera ~]$ cd /home/consultants/
[consultant2@servera consultants]$ echo "text" >> consultant1.txt
[consultant2@servera consultants]$ 
```

11.2. Use the cat command to verify that the text was added to the consultant1.txt file.

```
[consultant2@servera consultants]$ cat consultant1.txt
text
[consultant2@servera consultants]$ 
```

11.3. Exit the shell.

```
[consultant2@servera consultants]$ exit
logout
[student@servera ~]$ 
```

12. Log off from servera.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab perms-cli finish script to complete this exercise.

```
[student@workstation ~]$ lab perms-cli finish
```

This concludes the guided exercise.
