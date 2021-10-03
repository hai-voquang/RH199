# Guided Exercise 5.2: Controlling SELinux File Contexts

In this lab, you will make a persistent change to the SELinux context of a directory and its contents.

## Outcomes

You should be able to configure the Apache HTTP server to publish web content from a non-standard document root.

Log in as the student user on workstation using student as the password.

On workstation, run the lab selinux-filecontexts start command. This command runs a start script that determines whether the servera machine is reachable on the network. It also installs the httpd service and configures the firewall on servera to allow HTTP connections.

```
[student@workstation ~]$ lab selinux-filecontexts start
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

3. Configure Apache to use a document root in a non-standard location.

3.1. Create the new document root, /custom using the mkdir command.

```
[root@servera ~]# mkdir /custom
```

3.2. Create the index.html file in the /custom document root using the echo command.

```
[root@servera ~]# echo 'This is SERVERA.' > /custom/index.html
```

3.3. Configure Apache to use the new document root location. To do so, edit the Apache /etc/httpd/conf/httpd.conf configuration file and replace the two occurrences of /var/www/html with /custom.

```
...output omitted...
DocumentRoot "/custom"
...output omitted...
<Directory "/custom">
...output omitted...
```

4. Start and enable the Apache web service and confirm that the service is running.

4.1. Start and enable the Apache web service using the systemctl command.

```
[root@servera ~]# systemctl enable --now httpd
```

4.2. Use the systemctl command to confirm that the service is running.

```
[root@servera ~]# systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2019-03-25 19:16:48 CET; 15h ago
     Docs: man:httpd.service(8)
 Main PID: 6565 (httpd)
   Status: "Total requests: 16; Idle/Busy workers 100/0;Requests/sec: 0.000285; Bytes served/sec:   0 B/sec"
   Tasks: 213 (limit: 11406)
   Memory: 37.3M
   CGroup: /system.slice/httpd.service
           ├─6565 /usr/sbin/httpd -DFOREGROUND
           ├─6566 /usr/sbin/httpd -DFOREGROUND
           ├─6567 /usr/sbin/httpd -DFOREGROUND
           ├─6568 /usr/sbin/httpd -DFOREGROUND
           └─6569 /usr/sbin/httpd -DFOREGROUND

Mar 25 19:16:48 servera.lab.example.com systemd[1]: Starting The Apache HTTP Server...
Mar 25 19:16:48 servera.lab.example.com httpd[6565]: Server configured, listening on: port 80
Mar 25 19:16:48 servera.lab.example.com systemd[1]: Started The Apache HTTP Server.
```

5. Open a web browser on workstation and try to view http://servera/index.html. You will get an error message that says you do not have permission to access the file.

6. To permit access to the index.html file on servera, SELinux must be configured. Define an SELinux file context rule that sets the context type to httpd_sys_content_t for the /custom directory and all the files below it.

```
[root@servera ~]# semanage fcontext -a \
-t httpd_sys_content_t '/custom(/.*)?'
```

7. Use the restorecon command to change the file contexts.

```
[root@servera ~]# restorecon -Rv /custom
Relabeled /custom from unconfined_u:object_r:default_t:s0 to unconfined_u:object_r:httpd_sys_content_t:s0
Relabeled /custom/index.html from unconfined_u:object_r:default_t:s0 to unconfined_u:object_r:httpd_sys_content_t:s0
```

8. Try to view http://servera/index.html again. You should see the message This is SERVERA. displayed.

9. Exit from servera.

```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab selinux-filecontexts finish script to complete this exercise.

```
[student@workstation ~]$ lab selinux-filecontexts finish
```

This concludes the guided exercise.
