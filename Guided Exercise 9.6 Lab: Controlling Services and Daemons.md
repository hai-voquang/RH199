# Guided Exercise 9.6 Lab: Controlling Services and Daemons

## Performance Checklist

In this lab, you will configure several services to be enabled or disabled, running or stopped, based on a specification that is provided to you.

## Outcomes

You should be able to enable, disable, start, and stop services.

Log in as the student user on workstation using student as the password.

From workstation, run the lab services-review start command. The command runs a start script that determines whether the host, serverb, is reachable on the network. The script also ensures that the psacct and rsyslog services are configured appropriately on serverb.

```
[student@workstation ~]$ lab services-review start
```

1. On serverb, start the psacct service.

1.1. Use the ssh command to log in to serverb as the student user.

```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

1.2. Use the systemctl command to verify the status of the psacct service. Notice that psacct is stopped and disabled to start at boot time.

```
[student@serverb ~]$ systemctl status psacct
● psacct.service - Kernel process accounting
   Loaded: loaded (/usr/lib/systemd/system/psacct.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
```

1.3. Start the psacct service.

```
[student@serverb ~]$ sudo systemctl start psacct
[sudo] password for student: student
[student@serverb ~]$ 
```

1.4. Verify that the psacct service is running.

```
[student@serverb ~]$ systemctl is-active psacct
active
```

2. Configure the psacct service to start at system boot.

2.1. Enable the psacct service to start at system boot.

```
[student@serverb ~]$ sudo systemctl enable psacct
Created symlink /etc/systemd/system/multi-user.target.wants/psacct.service → /usr/lib/systemd/system/psacct.service.
```

2.2. Verify that the psacct service is enabled to start at system boot.

```
[student@serverb ~]$ systemctl is-enabled psacct
enabled
```

3. Stop the rsyslog service.

3.1. Use the systemctl command to verify the status of the rsyslog service. Notice that the rsyslog service is running and enabled to start at boot time.

```
[student@serverb ~]$ systemctl status rsyslog
● rsyslog.service - System Logging Service
   Loaded: loaded (/usr/lib/systemd/system/rsyslog.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2019-02-08 10:16:00 IST; 2h 34min ago
  ...output omitted...
```

Press q to exit the command.

3.2. Stop the rsyslog service.

```
[student@serverb ~]$ sudo systemctl stop rsyslog
[sudo] password for student: student
[student@serverb ~]$ 
```

3.3. Verify that the rsyslog service is stopped.

```
[student@serverb ~]$ systemctl is-active rsyslog
inactive
```

4. Configure the rsyslog service so that it does not start at system boot.

4.1. Disable the rsyslog service so that it does not start at system boot.

```
[student@serverb ~]$ sudo systemctl disable rsyslog
Removed /etc/systemd/system/syslog.service.
Removed /etc/systemd/system/multi-user.target.wants/rsyslog.service.
```

4.2. Verify that the rsyslog is disabled to start at system boot.

```
[student@serverb ~]$ systemctl is-enabled rsyslog
disabled
```

5. Reboot serverb before evaluating the lab.

```
[student@serverb ~]$ sudo systemctl reboot
Connection to serverb closed by remote host.
Connection to serverb closed.
[student@workstation ~]$ 
```

## Evaluation

On workstation, run the lab services-review grade script to confirm success on this lab.

```
[student@workstation ~]$ lab services-review grade
```

## Finish

On workstation, run the lab services-review finish script to complete this lab.

```
[student@workstation ~]$ lab services-review finish
```

This concludes the lab.

