# Guided Exercise 5.3: Adjusting SELinux Policy with Booleans

Apache can publish web content hosted in users' home directories, but SELinux prevents this by default. In this exercise, you will identify and change the SELinux boolean that permits Apache to access user home directories.

## Outcomes

You should be able to configure Apache to publish web content from users' home directories.

Log in as the student user on workstation using student as the password.

On workstation, run the lab selinux-booleans start command. This command runs a start script that determines whether the servera machine is reachable on the network. It also installs the httpd service and configures the firewall on servera to allow HTTP connections.

```
[student@workstation ~]$ lab selinux-booleans start
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

3. To enable the Apache feature that permits users to publish web content from their home directories, you must edit the /etc/httpd/conf.d/userdir.conf configuration file. Comment out the line that sets UserDir to disabled and uncomment the line that sets UserDir to public_html.

```
[root@servera ~]# vim /etc/httpd/conf.d/userdir.conf
#UserDir disabled
UserDir public_html 
```

4. Use the grep command to confirm the changes.

```
[root@servera ~]# grep '#UserDir' /etc/httpd/conf.d/userdir.conf
#UserDir disabled
[root@servera ~]# grep '^ *UserDir' /etc/httpd/conf.d/userdir.conf
UserDir public_html
```

5. Start and enable the Apache web service to make the changes take effect.

```
[root@servera ~]# systemctl enable --now httpd
```

6. In another terminal window log in as student. SSH into servera. Create some web content that is published from a user's home directory.

6.1. In another terminal window log in as student. Use the ssh command to log in to servera as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

6.2. Use the mkdir command to create a directory called ~/public_html.

```
[student@servera ~]$ mkdir ~/public_html
```

6.3. Create the index.html file with the following content:

```
[student@servera ~]$ echo 'This is student content on SERVERA.' > \
~/public_html/index.html
```

6.4. Use the chmod command to change the permissions on student's home directory so Apache can access the public_html subdirectory.

```
[student@servera ~]$ chmod 711 ~
```

7. Open a web browser on workstation and try to view the following URL: http://servera/~student/index.html. You get an error message that says you do not have permission to access the file.

8. In the terminal window with root access, use the getsebool command to see if there are any booleans that restrict access to home directories.

```
[root@servera ~]# getsebool -a | grep home
...output omitted...
httpd_enable_homedirs --> off
...output omitted...
```

9. In the terminal window with root access, use the setsebool command to enable home directory access persistently.

```
[root@servera ~]# setsebool -P httpd_enable_homedirs on
```

10. Try to view http://servera/~student/index.html again. You should see the message: This is student content on SERVERA.

11. Exit from servera.

```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab selinux-booleans finish script to complete this exercise.

```
[student@workstation ~]$ lab selinux-booleans finish
```

This concludes the guided exercise.
