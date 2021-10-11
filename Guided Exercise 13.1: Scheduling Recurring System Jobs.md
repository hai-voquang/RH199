# Guided Exercise 13.1: Scheduling Recurring System Jobs

In this exercise, you will schedule commands to run on various schedules by adding configuration files to the system crontab directories.

## Outcomes

You should be able to:

- Schedule a recurring system job to count the number of active users.

- Update the systemd timer unit that gathers system activity data.

Log in to workstation as student using student as the password.

On workstation, run lab scheduling-system start to start the exercise. This script ensures that the environment is clean and set up correctly.
```
[student@workstation ~]$ lab scheduling-system start
```

1. From workstation, open an SSH session to servera as student.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Use the sudo -i command to switch to the root user's account.
```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

3. Schedule a recurring system job that generates a log message indicating the number of currently active users in the system. The job must run daily. You can use the w -h | wc -l command to retrieve the number of currently active users in the system. Also, use the logger command to generate the log message.

3.1. Create a script file called /etc/cron.daily/usercount with the following content. You can use the vi /etc/cron.daily/usercount command to create the script file.
```
#!/bin/bash
USERCOUNT=$(w -h | wc -l)
logger "There are currently ${USERCOUNT} active users"
```

3.2. Use the chmod command to enable the execute (x) permission on /etc/cron.daily/usercount.
```
[root@servera ~]# chmod +x /etc/cron.daily/usercount
```

4. The sysstat package provides the systemd units called sysstat-collect.timer and sysstat-collect.service. The timer unit triggers the service unit every 10 minutes to collect system activity data using the shell script called /usr/lib64/sa/sa1. Make sure that the sysstat package is installed and change the timer unit configuration file to collect the system activity data every two minutes.

4.1. Use the yum command to install the sysstat package.
```
[root@servera ~]# yum install sysstat
...output omitted...
Is this ok [y/N]: y
...output omitted...
Installed:
  sysstat-11.7.3-2.el8.x86_64             lm_sensors-libs-3.4.0-17.20180522git70f7e08.el8.x86_64

Complete!
```

4.2. Copy /usr/lib/systemd/system/sysstat-collect.timer to /etc/systemd/system/sysstat-collect.timer.
```
[root@servera ~]# cp /usr/lib/systemd/system/sysstat-collect.timer \
/etc/systemd/system/sysstat-collect.timer
```

IMPORTANT
You should not edit files under the /usr/lib/systemd directory. With systemd, you can copy the unit file to the /etc/systemd/system directory and edit that copy. The systemd process parses your customized copy instead of the file under the /usr/lib/systemd directory.

4.3. Edit /etc/systemd/system/sysstat-collect.timer so that the timer unit runs every two minutes. Also, replace any occurrence of the string 10 minutes with 2 minutes throughout the unit configuration file including the ones in the commented lines. You may use the vi /etc/systemd/system/sysstat-collect.timer command to edit the configuration file.
```
...
#        Activates activity collector every 2 minutes

[Unit]
Description=Run system activity accounting tool every 2 minutes

[Timer]
OnCalendar=*:00/02

[Install]
WantedBy=sysstat.service
```
The preceding changes cause the sysstat-collect.timer unit to trigger sysstat-collect.service unit every two minutes, which runs /usr/lib64/sa/sa1 1 1. Running /usr/lib64/sa/sa1 1 1 collects the system activity data in a binary file under the /var/log/sa directory.

4.4. Use the systemctl daemon-reload command to make sure that systemd is aware of the changes.
```
[root@servera ~]# systemctl daemon-reload
```

4.5. Use the systemctl command to activate the sysstat-collect.timer timer unit.
```
[root@servera ~]# systemctl enable --now sysstat-collect.timer
```

4.6. Use the while command to wait until the binary file gets created under the /var/log/sa directory. Wait for your shell prompt to return.
```
[root@servera ~]# while [ $(ls /var/log/sa | wc -l) -eq 0 ];  \
do sleep 1s; done
```

In the while command above, the ls /var/log/sa | wc -l returns a 0 if the file does not exist and a 1 if it does exist. The while determines if this equals 0 and if so, enters the loop, which pauses for one second. When the file exists, the while loop exits.

4.7. Use the ls -l command to verify that the binary file under the /var/log/sa directory got modified within last two minutes.
```
[root@servera ~]# ls -l /var/log/sa
total 8
-rw-r--r--. 1 root root 5156 Mar 25 12:34 sa25
[root@servera ~]# date
Mon Mar 25 12:35:32 +07 2019
```

The output of the preceding commands may vary on your system.

4.8. Exit the root user's shell and log out of servera.
```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run lab scheduling-system finish to complete this exercise. This script deletes the files created throughout the exercise and ensures that the environment is clean.
```
[student@workstation ~]$ lab scheduling-system finish
```

This concludes the guided exercise.