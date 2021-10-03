# Guided Exercise 5.4: Investigating and Resolving SELinux Issues

In this lab, you will learn how to troubleshoot SELinux security denials.

## Outcomes

You should be able to gain experience using SELinux troubleshooting tools.

Log in as the student user on workstation using student as the password.

On workstation, run the lab selinux-issues start command. This command runs a start script that determines whether the servera machine is reachable on the network. It installs the httpd service, configures the firewall on servera to allow HTTP connections, and removes the SELinux context for the /custom directory.

```
[student@workstation ~]$ lab selinux-issues start
```

1. Open a web browser on workstation and try to view http://servera/index.html. You will get an error message that says you do not have permission to access the file.

2. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication, so a password is not required.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$  
```

3. Use the sudo -i command to switch to the root user. The password for the student user is student.

```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

4. Using the less command, view the contents of /var/log/messages. Use the / key and search for sealert. Copy the suggested sealert command so that it can be used in the next step. Use the q key to quit the less command.

```
[root@servera ~]# less /var/log/messages
...output omitted...
Mar 28 06:07:03 servera setroubleshoot[15326]: SELinux is preventing /usr/sbin/httpd from getattr access on the file /custom/index.html. For complete SELinux messages run: sealert -l b1c9cc8f-a953-4625-b79b-82c4f4f1fee3
Mar 28 06:07:03 servera platform-python[15326]: SELinux is preventing /usr/sbin/httpd from getattr access on the file /custom/index.html.#012#012*****  Plugin catchall (100. confidence) suggests   **************************#012#012If you believe that httpd should be allowed getattr access on the index.html file by default.#012Then you should report this as a bug.#012You can generate a local policy module to allow this access.#012Do#012allow this access for now by executing:#012# ausearch -c 'httpd' --raw | audit2allow -M my-httpd#012# semodule -X 300 -i my-httpd.pp#012
Mar 28 06:07:04 servera setroubleshoot[15326]: failed to retrieve rpm info for /custom/index.html
...output omitted...
```

5. Run the suggested sealert command. Note the source context, the target objects, the policy, and the enforcing mode.

```
[root@servera ~]# sealert -l b1c9cc8f-a953-4625-b79b-82c4f4f1fee3
SELinux is preventing /usr/sbin/httpd from getattr access on the file /custom/index.html.

*****  Plugin catchall (100. confidence) suggests   **************************

If you believe that httpd should be allowed getattr access on the index.html file by default.
Then you should report this as a bug.
You can generate a local policy module to allow this access.
Do
allow this access for now by executing:
# ausearch -c 'httpd' --raw | audit2allow -M my-httpd
# semodule -X 300 -i my-httpd.pp


Additional Information:
Source Context                system_u:system_r:httpd_t:s0
Target Context                unconfined_u:object_r:default_t:s0
Target Objects                /custom/index.html [ file ]
Source                        httpd
Source Path                   /usr/sbin/httpd
Port                          <Unknown>
Host                          servera.lab.example.com
Source RPM Packages
Target RPM Packages
Policy RPM                    selinux-policy-3.14.1-59.el8.noarch
Selinux Enabled               True
Policy Type                   targeted
Enforcing Mode                Enforcing
Host Name                     servera.lab.example.com
Platform                      Linux servera.lab.example.com
                              4.18.0-67.el8.x86_64 #1 SMP Sat Feb 9 12:44:00
                              UTC 2019 x86_64 x86_64
Alert Count                   18
First Seen                    2019-03-25 19:25:28 CET
Last Seen                     2019-03-28 11:07:00 CET
Local ID                      b1c9cc8f-a953-4625-b79b-82c4f4f1fee3

Raw Audit Messages
type=AVC msg=audit(1553767620.970:16958): avc:  denied  { getattr } for  pid=15067 comm="httpd" path="/custom/index.html" dev="vda1" ino=4208311 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:default_t:s0 tclass=file permissive=0


Hash: httpd,httpd_t,default_t,file,getattr
```

6. The Raw Audit Messages section of the sealert command contains information from the /var/log/audit/audit.log. Use the ausearch command to search the /var/log/audit/audit.log file. The -m option searches on the message type. The -ts option searches based on time. This entry identifies the relevant process and file causing the alert. The process is the httpd Apache web server, the file is /custom/index.html, and the context is system_r:httpd_t.

```
[root@servera ~]# ausearch -m AVC -ts recent
----
time->Thu Mar 28 13:39:30 2019
type=PROCTITLE msg=audit(1553776770.651:17000): proctitle=2F7573722F7362696E2F6874747064002D44464F524547524F554E44
type=SYSCALL msg=audit(1553776770.651:17000): arch=c000003e syscall=257 success=no exit=-13 a0=ffffff9c a1=7f8db803f598 a2=80000 a3=0 items=0 ppid=15063 pid=15065 auid=4294967295 uid=48 gid=48 euid=48 suid=48 fsuid=48 egid=48 sgid=48 fsgid=48 tty=(none) ses=4294967295 comm="httpd" exe="/usr/sbin/httpd" subj=system_u:system_r:httpd_t:s0 key=(null)
type=AVC msg=audit(1553776770.651:17000): avc:  denied  { open } for  pid=15065 comm="httpd" path="/custom/index.html" dev="vda1" ino=4208311 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:default_t:s0 tclass=file permissive=0
```

7. To resolve the issue use the semanage and restorecon commands. The context to manage is httpd_sys_content_t.

```
[root@servera ~]# semanage fcontext -a \
-t httpd_sys_content_t '/custom(/.*)?'
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

On workstation, run the lab selinux-issues finish script to complete this exercise.

```
[student@workstation ~]$ lab selinux-issues finish
```

This concludes the guided exercise.
