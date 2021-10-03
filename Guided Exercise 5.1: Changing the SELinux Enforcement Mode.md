Guided Exercise 5.1: Changing the SELinux Enforcement Mode

In this lab, you will manage SELinux modes, both temporarily and persistently.

## Outcomes

You should be able to view and set the current SELinux mode.

Log in as the student user on workstation using student as the password.

On workstation, run the lab selinux-opsmode start command. This command runs a start script that determines if the servera machine is reachable on the network.

```
[student@workstation ~]$ lab selinux-opsmode start
```

1. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication, so a password is not required.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$  
```

2. Use the sudo -i command to switch to the root user. The password for the student user is student.

```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

3. Change the default SELinux mode to permissive and reboot.

3.1. Use the getenforce command to verify that servera is in enforcing mode.

```
[root@servera ~]# getenforce
Enforcing 
```

3.2. Use the vim command to open the /etc/selinux/config configuration file. Change the SELINUX parameter from enforcing to permissive.

```
[root@servera ~]# vim /etc/selinux/config
```

3.3. Use the grep command to confirm that the SELINUX parameter is set to permissive.

```
[root@servera ~]# grep '^SELINUX' /etc/selinux/config
SELINUX=permissive
SELINUXTYPE=targeted 
```

3.4. Use the systemctl reboot command to reboot servera.

```
[root@servera ~]# systemctl reboot
Connection to servera closed by remote host.
Connection to servera closed.
[student@workstation ~]$  
```

4. servera takes a few minutes to reboot. After a few minutes, log in to servera as the student user. Use the sudo -i command to become root. Display the current SELinux mode using the getenforce command.

4.1. From workstation using the ssh command log in to servera as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

4.2. Use the sudo -i command to become root.

```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

4.3. Display the current SELinux mode using the getenforce command.

```
[root@servera ~]# getenforce
Permissive 
```

5. In the /etc/selinux/config file, change the default SELinux mode to enforcing. This change only takes effect on next reboot.

5.1. Use the vim command to open the /etc/selinux/config configuration file. Change the SELINUX back to enforcing.

```
[root@servera ~]# vim /etc/selinux/config
```

5.2. Use the grep command to confirm that the SELINUX parameter is set to enforcing.

```
[root@servera ~]# grep '^SELINUX' /etc/selinux/config
SELINUX=enforcing
SELINUXTYPE=targeted 
```

6. Use the setenforce command to set the current SELinux mode to enforcing without rebooting. Confirm that the mode has been set to enforcing using the getenforce command.

```
[root@servera ~]# setenforce 1
[root@servera ~]# getenforce
Enforcing
```

7. Exit from servera.

```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab selinux-opsmode finish script to complete this exercise.

```
[student@workstation ~]$ lab selinux-opsmode finish
```

This concludes the guided exercise.
