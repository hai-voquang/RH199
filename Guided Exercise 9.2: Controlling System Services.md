# Guided Exercise 9.2: Controlling System Services

In this exercise, you will use systemctl to stop, start, restart, reload, enable, and disable a systemd-managed service.

## Outcomes

You should be able to use the systemctl command to control systemd-managed services.

Log in as the student user on workstation using student as the password.

From workstation, run the lab services-control start command. The command runs a start script that determines whether the host, servera, is reachable on the network. The script also ensures that the sshd and chronyd services are running on servera.

```
[student@workstation ~]$ lab services-control start
```

1. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication, and therefore a password is not required.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Execute the systemctl restart and systemctl reload commands on the sshd service. Observe the different results of executing these commands.

2.1. Display the status of the sshd service. Note the process ID of the sshd daemon.

```
[student@servera ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2019-02-06 23:50:42 EST; 9min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 759 (sshd)
    Tasks: 1 (limit: 11407)
   Memory: 5.9M
...output omitted...
```

Press q to exit the command.

2.2. Restart the sshd service and view the status. The process ID of the daemon must change.

```
[student@servera ~]$ sudo systemctl restart sshd
[sudo] password for student: student
[student@servera ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2019-02-06 23:50:42 EST; 9min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 1132 (sshd)
    Tasks: 1 (limit: 11407)
   Memory: 5.9M
...output omitted...
```

In the preceding output, notice that the process ID changed from 759 to 1132 (on your system, the numbers likely will be different). Press q to exit the command.

2.3. Reload the sshd service and view the status. The process ID of the daemon must not change and connections are not interrupted.

```
[student@servera ~]$ sudo systemctl reload sshd
[student@servera ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2019-02-06 23:50:42 EST; 9min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 1132 (sshd)
    Tasks: 1 (limit: 11407)
   Memory: 5.9M
...output omitted...
```

Press q to exit the command.

3. Verify that the chronyd service is running.

```
[student@servera ~]$ systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2019-02-06 23:50:38 EST; 1h 25min ago
  ...output omitted...
```

Press q to exit the command.

4. Stop the chronyd service and view the status.

```
[student@servera ~]$ sudo systemctl stop chronyd
[student@servera ~]$ systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: inactive (dead) since Thu 2019-02-07 01:20:34 EST; 44s ago
  ...output omitted...
... servera.lab.example.com chronyd[710]: System clock wrong by 1.349113 seconds, adjustment started
... servera.lab.example.com systemd[1]: Stopping NTP client/server...
... servera.lab.example.com systemd[1]: Stopped NTP client/server.
```

Press q to exit the command.

5. Determine if the chronyd service is enabled to start at system boot.

```
[student@server ~]$ systemctl is-enabled chronyd
enabled
```

6. Reboot servera, then view the status of the chronyd service.

```
[student@servera ~]$ sudo systemctl reboot
Connection to servera closed by remote host.
Connection to servera closed.
[student@workstation ~]$ 
```
Log in as the student user on servera and view the status of the chronyd service.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2019-02-07 01:48:26 EST; 5min ago
   ...output omitted...
```
Press q to exit the command.

7. Disable the chronyd service so that it does not start at system boot, then view the status of the service.

```
[student@servera ~]$ sudo systemctl disable chronyd
[sudo] password for student: student
Removed /etc/systemd/system/multi-user.target.wants/chronyd.service.
[student@servera ~]$ systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; disabled; vendor preset: enabled)
   Active: active (running) since Thu 2019-02-07 01:48:26 EST; 5min ago
   ...output omitted...
```

Press q to exit the command.

8. Reboot servera, then view the status of the chronyd service.

```
[student@servera ~]$ sudo systemctl reboot
Connection to servera closed by remote host.
Connection to servera closed.
[student@workstation ~]$ 
```

Log in as the student user on servera and view the status of the chronyd service.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
   Docs: man:chronyd(8)
         man:chrony.conf(5)
```

9. Exit from servera.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation]$ 
```

## Finish

On workstation, run the lab services-control finish script to complete this exercise.

```
[student@workstation ~]$ lab services-control finish
```

This concludes the guided exercise.

