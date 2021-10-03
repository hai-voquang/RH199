# Guided Exercise 9.1: Identifying Automatically Started System Processes

In this exercise, you will list installed service units and identify which services are currently enabled and active on a server.

## Outcomes

You should be able to list installed service units and identify active and enabled services on the system.

Log in as the student user on workstation using student as the password.

From workstation, run the lab services-identify start command. The command runs a start script that determines if the host, servera, is reachable on the network.

```
[student@workstation ~]$ lab services-identify start
```

1. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication, therefore a password is not required to log in to servera.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. List all service units installed on servera.

```
[student@servera ~]$ systemctl list-units --type=service
UNIT                 LOAD   ACTIVE SUB     DESCRIPTION
atd.service          loaded active running Job spooling tools
auditd.service       loaded active running Security Auditing Service
chronyd.service      loaded active running NTP client/server
crond.service        loaded active running Command Scheduler
dbus.service         loaded active running D-Bus System Message Bus
...output omitted...
```

Press q to exit the command.

3. List all socket units, active and inactive, on servera.

```
[student@servera ~]$ systemctl list-units --type=socket --all
UNIT                 LOAD   ACTIVE   SUB       DESCRIPTION
dbus.socket          loaded active   running   D-Bus System Message Bus Socket 
dm-event.socket      loaded active   listening Device-mapper event daemon FIFOs
lvm2-lvmpolld.socket loaded active   listening LVM2 poll daemon socket
...output omitted...
systemd-udevd-control.socket    loaded active   running   udev Control Socket
systemd-udevd-kernel.socket     loaded active   running   udev Kernel Socket

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.

12 loaded units listed.
To show all installed unit files use 'systemctl list-unit-files'.
```

4. Explore the status of the chronyd service. This service is used for network time synchronization (NTP).

4.1. Display the status of the chronyd service. Note the process ID of any active daemon.

```
[student@servera ~]$ systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2019-02-06 12:46:57 IST; 4h 7min ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 684 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, status=0/SUCCESS)
  Process: 673 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
  Main PID: 680 (chronyd)
    Tasks: 1 (limit: 11406)
   Memory: 1.5M
   CGroup: /system.slice/chronyd.service
           └─680 /usr/sbin/chronyd

... servera.lab.example.com systemd[1]: Starting NTP client/server...
...output omitted...
... servera.lab.example.com systemd[1]: Started NTP client/server.
... servera.lab.example.com chronyd[680]: Source 172.25.254.254 offline
... servera.lab.example.com chronyd[680]: Source 172.25.254.254 online
... servera.lab.example.com chronyd[680]: Selected source 172.25.254.254
```

Press q to exit the command.

4.2. Confirm that the listed daemon is running. In the preceding command, the output of the process ID associated with the chronyd service is 680. The process ID might differ on your system.

```
[student@servera ~]$ ps -p 680
  PID TTY          TIME CMD
  680 ?        00:00:00 chronyd
```

5. Explore the status of the sshd service. This service is used for secure encrypted communication between systems.

5.1. Determine whether the sshd service is enabled to start at system boot.

```
[student@servera ~]$ systemctl is-enabled sshd
enabled
```

5.2. Determine if the sshd service is active without displaying all of the status information.

```
[student@servera ~]$ systemctl is-active sshd
active
```

5.3. Display the status of the sshd service.

```
[student@servera ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2019-02-06 12:46:58 IST; 4h 21min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 720 (sshd)
    Tasks: 1 (limit: 11406)
   Memory: 5.8M
   CGroup: /system.slice/sshd.service
   └─720 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,
   chacha20-poly1305@openssh.com,aes256-ctr,
   aes256-cbc,aes128-gcm@openssh.com,aes128-ctr,
   aes128-cbc -oMACs=hmac-sha2-256-etm@openssh.com,hmac-sha>

... servera.lab.example.com systemd[1]: Starting OpenSSH server daemon...
... servera.lab.example.com sshd[720]: Server listening on 0.0.0.0 port 22.
... servera.lab.example.com systemd[1]: Started OpenSSH server daemon.
... servera.lab.example.com sshd[720]: Server listening on :: port 22.
...output omitted...
... servera.lab.example.com sshd[1380]: pam_unix(sshd:session): session opened for user student by (uid=0)
```

Press q to exit the command.

6. List the enabled or disabled states of all service units.

```
[student@servera ~]$ systemctl list-unit-files --type=service
UNIT FILE                    STATE          
arp-ethers.service           disabled       
atd.service                  enabled        
auditd.service               enabled        
auth-rpcgss-module.service   static         
autovt@.service              enabled        
blk-availability.service     disabled       
chrony-dnssrv@.service       static         
chrony-wait.service          disabled       
chronyd.service              enabled 
...output omitted...
```

Press q to exit the command.

7. Exit from servera.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation]$ 
```

## Finish

On workstation, run the lab services-identify finish script to complete this exercise.

```
[student@workstation ~]$ lab services-identify finish
```

This concludes the guided exercise.

