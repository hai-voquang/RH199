
# Guided Exercise 3.1: Gaining Superuser Access
In this exercise, you will practice switching to the root account and running commands as root.

## Outcomes

You should be able to:

- Use sudo to switch to root and access the interactive shell as root without knowing the password of the superuser.

- Explain how su and su - can affect the shell environment through running or not running the login scripts.

- Use sudo to run other commands as root.

Log in to workstation as student using student as the password.

On workstation, run lab users-sudo start to start the exercise. This script creates the necessary user accounts and files to set up the environment correctly.

```
[student@workstation ~]$ lab users-sudo start
```

1. From workstation, open an SSH session to servera as student.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Explore the shell environment of student. View the current user and group information and display the current working directory. Also view the environment variables that specify the user's home directory and the locations of the user's executables.

2.1. Run id to view the current user and group information.

```
[student@servera ~]$ id
uid=1000(student) gid=1000(student) groups=1000(student),10(wheel) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

2.2. Run pwd to display the current working directory.

```
[student@servera ~]$ pwd
/home/student
```

2.3. Print the values of the HOME and PATH variables to determine the home directory and user executables' path, respectively.

```
[student@servera ~]$ echo $HOME
/home/student
[student@servera ~]$ echo $PATH
/home/student/.local/bin:/home/student/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
```

3. Switch to root in a non-login shell and explore the new shell environment.

3.1. Run sudo su at the shell prompt to become the root user.

```
[student@servera ~]$ sudo su
[sudo] password for student: student
[root@servera student]# 
```

3.2. Run id to view the current user and group information.

```
[root@servera student]# id
uid=0(root) gid=0(root) groups=0(root) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

3.3. Run pwd to display the current working directory.

```
[root@servera student]# pwd
/home/student
```

3.4. Print the values of the HOME and PATH variables to determine the home directory and user executables' path, respectively.

```
[root@servera student]# echo $HOME
/root
[root@servera student]# echo $PATH
/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
```

If you already have some experience with Linux and the su command, you may have expected that using su without the dash (-) option to become root would cause you to keep the current PATH of student. That did not happen. As you will see in the next step, this is not the usual PATH for root either.

What happened? The difference is that you did not run su directly. Instead, you ran su as root using sudo because you did not possess the password of the superuser. The sudo command initially overrides the PATH variable from the initial environment for security reasons. Any command that runs after the initial override can still update the PATH variable, as you will see in the following steps.

3.5. Exit the root user's shell to return to the student user's shell.

```
[root@servera student]# exit
exit
[student@servera ~]$ 
```

4. Switch to root in a login shell and explore the new shell environment.

4.1 Run sudo su - at the shell prompt to become the root user.

```
[student@servera ~]$ sudo su -
[root@servera ~]# 
```

Notice the difference in the shell prompt compared to that of sudo su in the preceding step.

sudo may or may not prompt you for the student password, depending on the time-out period of sudo. The default time-out period is five minutes. If you have authenticated to sudo within the last five minutes, sudo will not prompt you for the password. If it has been more than five minutes since you authenticated to sudo, you need to enter student as the password to get authenticated to sudo.

4.2. Run id to view the current user and group information.

```
[root@servera ~]# id
uid=0(root) gid=0(root) groups=0(root) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

4.3. Run pwd to display the current working directory.

```
[root@servera ~]# pwd
/root
```

4.4. Print the values of the HOME and PATH variables to determine the home directory and the user executables' path, respectively.

```
[root@servera ~]# echo $HOME
/root
[root@servera ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```

As in the preceding step, after sudo reset the PATH variable from the settings in the student user's shell environment, the su - command ran the shell login scripts for root and set the PATH variable to yet another value. The su command without the dash (-) option did not do that.

4.5. Exit the root user's shell to return to the student user's shell.

```
[root@servera ~]# exit
logout
[student@servera ~]$ 
```

5. Verify that the operator1 user is configured as to run any command as any user using sudo.

```
[student@servera ~]$ sudo cat /etc/sudoers.d/operator1
operator1 ALL=(ALL) ALL
```

6. Become operator1 and view the contents of /var/log/messages. Copy /etc/motd to /etc/motdOLD and remove it (/etc/motdOLD). These operations require administrative rights and so use sudo to run those commands as the superuser. Do not switch to root using sudo su or sudo su -. Use redhat as the password of operator1.

6.1. Switch to operator1.

```
[student@servera ~]$ su - operator1
Password: redhat
[operator1@servera ~]$ 
```

6.2. Attempt to view the last five lines of /var/log/messages without using sudo. This should fail.

```
[operator1@servera ~]$ tail -5 /var/log/messages
tail: cannot open '/var/log/messages' for reading: Permission denied
```

6.3. Attempt to view the last five lines of /var/log/messages with sudo. This should succeed.

```
[operator1@servera ~]$ sudo tail -5 /var/log/messages
[sudo] password for operator1: redhat
Jan 23 15:53:36 servera su[2304]: FAILED SU (to operator1) student on pts/1
Jan 23 15:53:51 servera su[2307]: FAILED SU (to operator1) student on pts/1
Jan 23 15:53:58 servera su[2310]: FAILED SU (to operator1) student on pts/1
Jan 23 15:54:12 servera su[2322]: (to operator1) student on pts/1
Jan 23 15:54:25 servera su[2353]: (to operator1) student on pts/1
```

6.4. Attempt to make a copy of /etc/motd as /etc/motdOLD without using sudo. This should fail.

```
[operator1@servera ~]$ cp /etc/motd /etc/motdOLD
cp: cannot create regular file '/etc/motdOLD': Permission denied
```

6.5. Attempt to make a copy of /etc/motd as /etc/motdOLD with sudo. This should succeed.

```
[operator1@servera ~]$ sudo cp /etc/motd /etc/motdOLD
[operator1@servera ~]$ 
```

6.6. Attempt to delete /etc/motdOLD without using sudo. This should fail.

```
[operator1@servera ~]$ rm /etc/motdOLD
rm: remove write-protected regular empty file '/etc/motdOLD'? y
rm: cannot remove '/etc/motdOLD': Permission denied
[operator1@servera ~]$ 
```

6.7. Attempt to delete /etc/motdOLD with sudo. This should succeed.

```
[operator1@servera ~]$ sudo rm /etc/motdOLD
[operator1@servera ~]$ 
```

6.8. Exit the operator1 user's shell to return to the student user's shell.

```
[operator1@servera ~]$ exit
logout
[student@servera ~]$ 
```

6.9. Log off from servera.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run lab users-sudo finish to complete this exercise. This script deletes the user accounts and files created at the start of the exercise to ensure that the environment is clean.

```
[student@workstation ~]$ lab users-sudo finish
```

This concludes the guided exercise.
