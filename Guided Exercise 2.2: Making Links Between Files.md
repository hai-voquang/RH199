# Guided Exercise 2.2: Making Links Between Files

In this exercise, you will create hard links and symbolic links and compare the results.

## Outcomes

You should be able to create hard links and soft links between files.

Log in as the student user on workstation using student as the password.

On workstation, run the lab files-make start command. This command runs a start script that determines if the servera host is reachable on the network and creates the files and working directories on servera.

```
[student@workstation ~]$ lab files-make start
```

1. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication, and therefore a password is not required.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Create a hard link named /home/student/backups/source.backup for the existing file, /home/student/files/source.file.

2.1. View the link count for the file, /home/student/files/source.file.

```
[student@servera ~]$ ls -l files/source.file
total 4
-rw-r--r--. 1 student student 11 Mar  5 21:19 source.file
```

2.2. Create a hard link named /home/student/backups/source.backup. Link it to the file, /home/student/files/source.file.

```
[student@servera ~]$ ln /home/student/files/source.file \
/home/student/backups/source.backup
```

2.3. Verify the link count for the original /home/student/files/source.file and the new linked file, /home/student/backups/source.backup. The link count should be 2 for both files.

```
[student@servera ~]$ ls -l /home/student/files/
-rw-r--r--. 2 student student 11 Mar  5 21:19 source.file
[student@servera ~]$ ls -l /home/student/backups/
-rw-r--r--. 2 student student 11 Mar  5 21:19 source.backup
```

3. Create a soft link named /home/student/tempdir that points to the /tmp directory on servera.

3.1. Create a soft link named /home/student/tempdir and link it to /tmp.

```
[student@servera ~]$ ln -s /tmp /home/student/tempdir
```

3.2. Use the ls -l command to verify the newly created soft link.

```
[student@servera ~]$ ls -l /home/student/tempdir
lrwxrwxrwx. 1 student student  4 Mar  5 22:04 /home/student/tempdir -> /tmp
```

4. Exit from servera.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$
```

## Finish

On workstation, run the lab files-make finish script to finish this exercise. This script removes all files and directories created on servera during the exercise.

```
[student@workstation ~]$ lab files-make finish
```

This concludes the guided exercise.
