# Guided Exercise 5.5 Lab: Managing SELinux Security

## Performance Checklist

In this lab, you will solve an SELinux access denial problem. System administrators are having trouble getting a new web server to deliver content to clients when SELinux is in enforcing mode.

## Outcomes

You should be able to:

- Identify issues in system log files.

- Adjust the SELinux configuration.

Log in to workstation as student using student as the password.

On workstation, run the lab selinux-review start command. This command runs a start script that determines whether the serverb machine is reachable on the network. It also installs the httpd Apache server, creates a new DocumentRoot for Apache, and updates the configuration file.

```
[student@workstation ~]$ lab selinux-review start
```

1. Log in to serverb as the root user.

1.1. Use the ssh command to log in to serverb as the student user. The systems are configured to use SSH keys for authentication, so a password is not required.

```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$  
```

1.2. Use the sudo -i command to switch to the root user. The password for the student user is student.

```
[student@serverb ~]$ sudo -i
[sudo] password for student: student
[root@serverb ~]# 
```

2. Launch a web browser on workstation and browse to http://serverb/lab.html. You will see the error message: You do not have permission to access /lab.html on this server.

3. Research and identify the SELinux issue that is preventing Apache from serving web content.

3.1. Using the less command, view the contents of /var/log/messages. Use the / key and search for sealert. Use the q key to quit the less command.

```
[root@serverb ~]# less /var/log/messages
Mar 28 10:19:51 serverb setroubleshoot[27387]: SELinux is preventing /usr/sbin/httpd from getattr access on the file /lab-content/lab.html. For complete SELinux messages run: sealert -l 8824e73d-3ab0-4caf-8258-86e8792fee2d
Mar 28 10:19:51 serverb platform-python[27387]: SELinux is preventing /usr/sbin/httpd from getattr access on the file /lab-content/lab.html.#012#012*****  Plugin catchall (100. confidence) suggests   **************************#012#012If you believe that httpd should be allowed getattr access on the lab.html file by default.#012Then you should report this as a bug.#012You can generate a local policy module to allow this access.#012Do#012allow this access for now by executing:#012# ausearch -c 'httpd' --raw | audit2allow -M my-httpd#012# semodule -X 300 -i my-httpd.pp#012
```

3.2. Run the suggested sealert command. Note the source context, the target objects, the policy, and the enforcing mode.

```
[root@serverb ~]# sealert -l 8824e73d-3ab0-4caf-8258-86e8792fee2d
SELinux is preventing /usr/sbin/httpd from getattr access on the file /lab-content/lab.html.

*****  Plugin catchall (100. confidence) suggests   **************************

If you believe that httpd should be allowed getattr access on the lab.html file by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'httpd' --raw | audit2allow -M my-httpd
# semodule -X 300 -i my-httpd.pp


Additional Information:
Source Context                system_u:system_r:httpd_t:s0
Target Context                unconfined_u:object_r:default_t:s0
Target Objects                /lab-content/lab.html [ file ]
Source                        httpd
Source Path                   /usr/sbin/httpd
Port                          <Unknown>
Host                          serverb.lab.example.com
Source RPM Packages
Target RPM Packages
Policy RPM                    selinux-policy-3.14.1-59.el8.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Enforcing
Host Name                     serverb.lab.example.com
Platform                      Linux serverb.lab.example.com
                              4.18.0-67.el8.x86_64 #1 SMP Sat Feb 9 12:44:00
                              UTC 2019 x86_64 x86_64
Alert Count                   2
First Seen                    2019-03-28 15:19:46 CET
Last Seen                     2019-03-28 15:19:46 CET
Local ID                      8824e73d-3ab0-4caf-8258-86e8792fee2d

Raw Audit Messages
type=AVC msg=audit(1553782786.213:864): avc:  denied  { getattr } for  pid=15606 comm="httpd" path="/lab-content/lab.html" dev="vda1" ino=8763212 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:default_t:s0 tclass=file permissive=0


Hash: httpd,httpd_t,default_t,file,getattr
```

3.3. The Raw Audit Messages section of the sealert command contains information from the /var/log/audit/audit.log. Use the ausearch command to search the /var/log/audit/audit.log file. The -m option searches on the message type. The ts option searches based on time. This entry identifies the relevant process and file causing the alert. The process is the httpd Apache web server, the file is /lab-content/lab.html, and the context is system_r:httpd_t.

```
[root@serverb ~]# ausearch -m AVC -ts recent
time->Thu Mar 28 15:19:46 2019
type=PROCTITLE msg=audit(1553782786.213:864): proctitle=2F7573722F7362696E2F6874747064002D44464F524547524F554E44
type=SYSCALL msg=audit(1553782786.213:864): arch=c000003e syscall=6 success=no exit=-13 a0=7fb900004930 a1=7fb92dfca8e0 a2=7fb92dfca8e0 a3=1 items=0 ppid=15491 pid=15606 auid=4294967295 uid=48 gid=48 euid=48 suid=48 fsuid=48 egid=48 sgid=48 fsgid=48 tty=(none) ses=4294967295 comm="httpd" exe="/usr/sbin/httpd" subj=system_u:system_r:httpd_t:s0 key=(null)
type=AVC msg=audit(1553782786.213:864): avc:  denied  { getattr } for  pid=15606 comm="httpd" path="/lab-content/lab.html" dev="vda1" ino=8763212 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:default_t:s0 tclass=file permissive=0
```

4. Display the SELinux context of the new HTTP document root and the original HTTP document root. Resolve the SELinux issue preventing Apache from serving web content.

4.1. Use the ls -dZ to compare the document root of /lab-content and /var/www/html.

```
[root@serverb ~]# ls -dZ /lab-content /var/www/html
unconfined_u:object_r:default_t:s0 /lab-content/  system_u:object_r:httpd_sys_content_t:s0 /var/www/html/
```

4.2. Create a file context rule that sets the default type to httpd_sys_content_ for /lab-content and all the files below it.

```
[root@serverb ~]# semanage fcontext -a \
-t httpd_sys_content_t '/lab-content(/.*)?'
```

4.3. Use the restorecon command to set the SELinux context for the files in /lab-content.

```
[root@serverb ~]# restorecon -R /lab-content/
```

5. Verify that the SELinux issue has been resolved and Apache is able to serve web content.

Use your web browser to refresh the http://serverb/lab.html link. Now you should see some web content.

```
This is the html file for the SELinux final lab on SERVERB. 
```

6. Exit from serverb.

```
[root@serverb ~]# exit
logout
[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$ 
```

## Evaluation

On workstation, run the lab selinux-review grade script to confirm success on this exercise.

```
[student@workstation ~]$ lab selinux-review grade
```

## Finish

On workstation, run the lab selinux-review finish script to complete the lab.

```
[student@workstation ~]$ lab selinux-review finish
```

This concludes the lab.
