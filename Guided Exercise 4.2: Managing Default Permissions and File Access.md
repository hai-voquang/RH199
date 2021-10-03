# Guided Exercise 4.2: Managing Default Permissions and File Access

In this exercise, you will control the permissions on new files created in a directory by using umask settings and the setgid permission.

## Outcomes

You should be able to:

- Create a shared directory where new files are automatically owned by the operators group.

- Experiment with various umask settings.

- Adjust default permissions for specific users.

- Confirm your adjustment is correct.

Log in to workstation as student using student as the password.

On workstation, run the lab perms-default start command. The command runs a start script that determines if servera is reachable on the network. The script also creates the operators group and the operator1 user on servera.

```
[student@workstation ~]$ lab perms-default start
```

1. Use the ssh command to log in to servera as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Use the su command to switch to the operator1 user using redhat as the password.

```
[student@servera ~]$ su - operator1
Password: redhat
[operator1@servera ~]$ 
```

3. Use the umask command to list the operator1 user's default umask value.

```
[operator1@servera ~]$ umask
0002
```

4. Create a new directory named /tmp/shared. In the /tmp/shared directory, create a file named defaults. Look at the default permissions.

4.1 Use the mkdir command to create the /tmp/shared directory. Use the ls -ld command to list the permissions of the new directory.

```
[operator1@servera ~]$ mkdir /tmp/shared
[operator1@servera ~]$ ls -ld /tmp/shared
drwxrwxr-x. 2 operator1 operator1 6 Feb  4 14:06 /tmp/shared
```

4.2. Use the touch command to create a file named defaults in the /tmp/shared directory.

```
[operator1@servera ~]$ touch /tmp/shared/defaults
```

4.3. Use the ls -l command to list the permissions of the new file.

```
[operator1@servera ~]$ ls -l /tmp/shared/defaults
-rw-rw-r--. 1 operator1 operator1 0 Feb  4 14:09 /tmp/shared/defaults
```

5. Change the group ownership of /tmp/shared to operators. Confirm the new ownership and permissions.

5.1 Use the chown command to change the group ownership of the /tmp/shared directory to operators.

```
[operator1@servera ~]$ chown :operators /tmp/shared
```

5.2. Use the ls -ld command to list the permissions of the /tmp/shared directory.

```
[operator1@servera ~]$ ls -ld /tmp/shared
drwxrwxr-x. 2 operator1 operators 22 Feb  4 14:09 /tmp/shared 
```

5.3. Use the touch command to create a file named group in the /tmp/shared directory. Use the ls -l command to list the file permissions.

```
[operator1@servera ~]$ touch /tmp/shared/group
[operator1@servera ~]$ ls -l /tmp/shared/group
-rw-rw-r--. 1 operator1 operator1 0 Feb  4 17:00 /tmp/shared/group
```

6. Ensure that files created in the /tmp/shared directory are owned by the operators group.

6.1 Use the chmod command to set the group ID to the operators group for the /tmp/shared directory.

```
[operator1@servera ~]$ chmod g+s /tmp/shared
```

6.2. Use the touch command to create a new file named operations_database.txt in the /tmp/shared directory.

```
[operator1@servera ~]$ touch /tmp/shared/operations_database.txt
```

6.3. Use the ls -l command to verify that the operators group is the group owner for the new file.

```
[operator1@servera ~]$ ls -l /tmp/shared/operations_database.txt
-rw-rw-r--. 1 operator1 operators 0 Feb  4 16:11 /tmp/shared/operations_database.txt 
```

7. Create a new file in the /tmp/shared directory named operations_network.txt. Record the ownership and permissions. Change the umask for operator1. Create a new file called operations_production.txt. Record the ownership and permissions of the operations_production.txt file.

7.1. Use the touch command to create a file called operations_network.txt in the /tmp/shared directory.

```
[operator1@servera ~]$ touch /tmp/shared/operations_network.txt
```

7.2. Use the ls -l command to list the permissions of the operations_network.txt file.

```
[operator1@servera ~]$ ls -l /tmp/shared/operations_network.txt
-rw-rw-r--. 1 operator1 operators 5 Feb  0 15:43 /tmp/shared/operations_network.txt 
```

7.3. Use the umask command to change the umask for the operator1 user to 027. Use the umask command to confirm the change.

```
[operator1@servera ~]$ umask 027
[operator1@servera ~]$ umask
0027
```

7.4. Use the touch command to create a new file named operations_production.txt in the /tmp/shared/ directory. Use the ls -l command to ensure that newly created files are created with read-only access for the operators group and no access for other users.

```
[operator1@servera ~]$ touch /tmp/shared/operations_production.txt
[operator1@servera ~]$ ls -l /tmp/shared/operations_production.txt
-rw-r-----. 1 operator1 operators 0 Feb  0 15:56 /tmp/shared/operations_production.txt 
```

8. Open a new terminal window and log in to servera as operator1.

```
[student@workstation ~]$ ssh operator1@servera
...output omitted...
[operator1@servera ~]$ 
```

9. List the umask value for operator1.

```
[operator1@servera ~]$ umask
0002 
```

10. Change the default umask for the operator1 user. The new umask prohibits all access for users not in their group. Confirm that the umask has been changed.

10.1. Use the echo command to change the default umask for the operator1 user to 007.

```
[operator1@servera ~]$ echo "umask 007" >> ~/.bashrc
[operator1@servera ~]$ cat ~/.bashrc
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
umask 007
```

10.2. Log out and log in again as the operator1 user. Use the umask command to confirm that the change is permanent.

```
[operator1@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ ssh operator1@servera
...output omitted...
[operator1@servera ~]$ umask
0007
```

11. On servera, exit from all the operator1 and the student user shells.

WARNING
Exit from all shells opened by operator1. Failure to exit from all shells will cause the finish script to fail.

```
[operator1@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab perms-default finish script to complete this exercise.

```
[student@workstation ~]$ lab perms-default finish
```

This concludes the guided exercise.
