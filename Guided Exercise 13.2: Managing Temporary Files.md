# Guided Exercise 13.2: Managing Temporary Files

Guided Exercise: Managing Temporary Files
In this exercise, you will configure systemd-tmpfiles in order to change how quickly it removes temporary files from /tmp, and also to periodically purge files from another directory.

## Outcomes

You should be able to:

- Configure systemd-tmpfiles to remove unused temporary files from /tmp.

- Configure systemd-tmpfiles to periodically purge files from another directory.

Log in to workstation as student using student as the password.

On workstation, run lab scheduling-tempfiles start to start the exercise. This script creates the necessary files and ensures that the environment is set up correctly.
```
[student@workstation ~]$ lab scheduling-tempfiles start
```

1. From workstation, open an SSH session to servera as student.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Configure systemd-tmpfiles to clean the /tmp directory so that it does not contain files that that have not been used in the last five days. Ensure that the configuration does not get overwritten by any package update.

2.1. Use the sudo -i command to switch to the root user.
```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

2.2. Copy /usr/lib/tmpfiles.d/tmp.conf to /etc/tmpfiles.d/tmp.conf.
```
[root@servera ~]# cp /usr/lib/tmpfiles.d/tmp.conf \
/etc/tmpfiles.d/tmp.conf
```

2.3. Search for the configuration line in /etc/tmpfiles.d/tmp.conf that applies to the /tmp directory. Replace the existing age of the temporary files in that configuration line with the new age of 5 days. Remove all the other lines from the file including the commented ones. You can use the vim /etc/tmpfiles.d/tmp.conf command to edit the configuration file. The /etc/tmpfiles.d/tmp.conf file should appear as follows:
```
q /tmp 1777 root root 5d
```
In the preceding configuration, the q type is identical to d and instructs systemd-tmpfiles to create the /tmp directory if it does not exist. The directory must have the octal permissions set to 1777. Both the owning user and group of /tmp must be root. The /tmp directory must be free from the temporary files which are unused in the last five days.

2.4. Use the systemd-tmpfiles --clean command to verify that the /etc/tmpfiles.d/tmp.conf file contains the correct configuration.
```
[root@servera ~]# systemd-tmpfiles --clean /etc/tmpfiles.d/tmp.conf
```

Because the preceding command did not return any errors, it confirms that the configuration settings are correct.

3. Add a new configuration that ensures that the /run/momentary directory exists with user and group ownership set to root. The octal permissions for the directory must be 0700. The configuration should purge any file in this directory that remains unused in the last 30 seconds.

3.1. Create the file called /etc/tmpfiles.d/momentary.conf with the following content. You can use the vim /etc/tmpfiles.d/momentary.conf command to create the configuration file.
```
d /run/momentary 0700 root root 30s
```
The preceding configuration causes systemd-tmpfiles to ensure that the /run/momentary directory exists with its octal permissions set to 0700. The user and group ownership of /run/momentary must be root. Any file in this directory that remains unused in the last 30 seconds must be purged.

3.2. Use the systemd-tmpfiles --create command to verify that the /etc/tmpfiles.d/momentary.conf file contains the appropriate configuration. The command creates the /run/momentary directory if it does not exist.
```
[root@servera ~]# systemd-tmpfiles --create \
/etc/tmpfiles.d/momentary.conf
```

Because the preceding command did not return any errors, it confirms that the configuration settings are correct.

3.3. Use the ls command to verify that the /run/momentary directory is created with the appropriate permissions, owner, and group owner.
```
[root@servera ~]# ls -ld /run/momentary
drwx------. 2 root root 40 Mar 21 16:39 /run/momentary
```
Notice that the octal permission set of /run/momentary is 0700 and that the user and group ownership are set to root.

4. Verify that any file under the /run/momentary directory, unused in the last 30 seconds, is removed, based on the systemd-tmpfiles configuration for the directory.

4.1. Use the touch command to create a file called /run/momentary/testfile.
```
[root@servera ~]# touch /run/momentary/testfile
```

4.2. Use the sleep command to configure your shell prompt not to return for 30 seconds.
```
[root@servera ~]# sleep 30
```            

4.3. After your shell prompt returns, use the systemd-tmpfiles --clean command to clean stale files from /run/momentary, based on the rule mentioned in /etc/tmpfiles.d/momentary.conf.
```
[root@servera ~]# systemd-tmpfiles --clean \
/etc/tmpfiles.d/momentary.conf
```
The preceding command removes /run/momentary/testfile because the file remained unused for 30 seconds and should have been removed based on the rule mentioned in /etc/tmpfiles.d/momentary.conf.

4.4. Use the ls -l command to verify that the /run/momentary/testfile file does not exist.
```
[root@servera ~]# ls -l /run/momentary/testfile
ls: cannot access '/run/momentary/testfile': No such file or directory
```

4.5. Exit the root user's shell and log out of servera.
```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run lab scheduling-tempfiles finish to complete this exercise. This script deletes the files created throughout the exercise and ensures that the environment is clean.
```
[student@workstation ~]$ lab scheduling-tempfiles finish
```

This concludes the guided exercise.