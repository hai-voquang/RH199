# Guided Exercise 15.1: Managing Server Firewalls

In this exercise, you will control access to system services by adjusting system firewall rules with firewalld.

## Outcomes

You should be able to configure firewall rules to control access to services.

Log in as the student user on workstation using student as the password.

From workstation, run the lab netsecurity-firewalls start command. The command runs a start script to determine whether the servera host is reachable on the network.
```
[student@workstation ~]$ lab netsecurity-firewalls start
```

1. From workstation, use SSH to log in to servera as student user. The systems are configured to use SSH keys for authentication, so a password is not required.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. On the servera system, ensure that both httpd and mod_ssl packages are installed. These packages provide the Apache web server you will protect with a firewall, and the necessary extensions for the web server to serve content over SSL.
```
[student@servera ~]$ sudo yum install httpd mod_ssl
[sudo] password for student: student
...output omitted...
Is this ok [y/N]: y
...output omitted...
Complete!
```

3. As the student user on servera, create the /var/www/html/index.html file. Add one line of text that reads: I am servera.
```
[student@servera ~]$ sudo bash -c \
"echo 'I am servera.' > /var/www/html/index.html"
```

4. Start and enable the httpd service on your servera system.
```
[student@servera ~]$ sudo systemctl enable --now httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
```

5. Exit from servera.
```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$
```

6. From workstation, attempt to access your web server on servera using both the cleartext port 80/TCP and the SSL encapsulated port 443/TCP. Both attempts should fail.

6.1. This command should fail:
```
[student@workstation ~]$ curl http://servera.lab.example.com
curl: (7) Failed to connect to servera.lab.example.com port 80: No route to host
```

6.2. This command should also fail:
```
[student@workstation ~]$ curl -k https://servera.lab.example.com
curl: (7) Failed to connect to servera.lab.example.com port 443: No route to host
```

7. Log in to servera as the student user.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

8. On servera, make sure that the nftables service is masked and the firewalld service is enabled and running.

8.1. Determine whether the status of the nftables service is masked.
```
[student@servera ~]$ sudo systemctl status nftables
[sudo] password for student: student
● nftables.service - Netfilter Tables
   Loaded: loaded (/usr/lib/systemd/system/nftables.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: man:nft(8)
```

The results show that nftables is disabled and inactive but not masked. Run the following command to mask the service.
```
[student@servera ~]$ sudo systemctl mask nftables
Created symlink /etc/systemd/system/nftables.service → /dev/null.
```

8.2. Verify that the status of the nftables service is masked.
```
[student@servera ~]$ sudo systemctl status nftables
● nftables.service
   Loaded: masked (Reason: Unit nftables.service is masked.)
   Active: inactive (dead)
```

8.3. Verify that the status of the firewalld service is enabled and running.
```
[student@servera ~]$ sudo systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2019-05-22 15:36:02 CDT; 5min ago
     Docs: man:firewalld(1)
 Main PID: 703 (firewalld)
    Tasks: 2 (limit: 11405)
   Memory: 29.8M
   CGroup: /system.slice/firewalld.service
           └─703 /usr/libexec/platform-python -s /usr/sbin/firewalld --nofork --nopid

May 22 15:36:01 servera.lab.example.com systemd[1]: Starting firewalld - dynamic firewall daemon...
May 22 15:36:02 servera.lab.example.com systemd[1]: Started firewalld - dynamic firewall daemon.
```

8.4. Exit from servera.
```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$
```

9. From workstation, open Firefox and log in to the Web Console running on servera to add the httpd service to the public network zone.

9.1. Open Firefox and browse to https://servera.lab.example.com:9090 to access the Web Console. Accept the self-signed certificate used by servera by adding an exception.

9.2. Select the check box next to Reuse my password for privileged tasks to ensure administrative privileges.

Log in as student user with student as the password.

9.3. Click Networking in the left navigation bar.

9.4. Click the Firewall link in main Networking page.

9.5. Click the Add Services... button located in the upper right side of the Firewall page.

9.6. In the Add Services user interface, scroll down or use Filter Services to locate and select the check box next to the Secure WWW (HTTPS) service.

9.7. Click the Add Services button located at the lower right side of the Add Services user interface.

10. Return to a terminal on workstation and verify your work by attempting to view the web server contents of servera.

10.1. This command should fail:
```
[student@workstation ~]$ curl http://servera.lab.example.com
curl: (7) Failed to connect to servera.lab.example.com port 80: No route to host
```

10.2. This command should succeed:
```
[student@workstation ~]$ curl -k https://servera.lab.example.com
I am servera.
```

NOTE
If you use Firefox to connect to the web server, it will prompt for verification of the host certificate if it successfully gets past the firewall.

## Finish

On workstation, run the lab netsecurity-firewalls finish script to complete this exercise.
```
[student@workstation ~]$ lab netsecurity-firewalls finish
```
This concludes the guided exercise.