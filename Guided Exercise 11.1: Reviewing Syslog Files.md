# Guided Exercise 11.1: Reviewing Syslog Files

In this exercise, you will reconfigure rsyslog to write specific log messages to a new file.

## Outcomes

You should be able to configure the rsyslog service to write all log messages with the debug priority to the /var/log/messages-debug log file.

Log in to workstation as student using student as the password.

On workstation, run lab log-configure start to start the exercise. This script ensures that the environment is setup correctly.
```
[student@workstation ~]$ lab log-configure start
```

1. From workstation, open an SSH session to servera as student.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Configure rsyslog on servera to log all messages with the debug priority, or higher, for any service into the new /var/log/messages-debug log file by adding the rsyslog configuration file /etc/rsyslog.d/debug.conf.

2.1. Use the sudo -i command to switch to the root user. Specify student as the password for the student user if asked while running the sudo -i command.
```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

2.2. Create the /etc/rsyslog.d/debug.conf file with the necessary entries to redirect all log messages having the debug priority to /var/log/messages-debug. You may use the vim /etc/rsyslog.d/debug.conf command to create the file with the following content.
```
*.debug /var/log/messages-debug
```

This configuration line catches syslog messages with any facility and a debug or above priority level. The rsyslog service will write the matching messages to the /var/log/messages-debug file. The wildcard (*) in the facility or priority fields of the configuration line indicates any facility or priority.

2.3. Restart the rsyslog service.
```
[root@servera ~]# systemctl restart rsyslog
```

3. Verify that all the log messages with the debug priority appears in the /var/log/messages-debug file.

3.1. Use the logger command with the -p option to generate a log message with the user facility and the debug priority.
```
[root@servera ~]# logger -p user.debug "Debug Message Test"
```

3.2. Use the tail command to view the last ten log messages from the /var/log/messages-debug file and confirm that you see the Debug Message Test message among the other log messages.
```
[root@servera ~]# tail /var/log/messages-debug
Feb 13 18:22:38 servera systemd[1]: Stopping System Logging Service...
Feb 13 18:22:38 servera rsyslogd[25176]: [origin software="rsyslogd" swVersion="8.37.0-9.el8" x-pid="25176" x-info="http://www.rsyslog.com"] exiting on signal 15.
Feb 13 18:22:38 servera systemd[1]: Stopped System Logging Service.
Feb 13 18:22:38 servera systemd[1]: Starting System Logging Service...
Feb 13 18:22:38 servera rsyslogd[25410]: environment variable TZ is not set, auto correcting this to TZ=/etc/localtime  [v8.37.0-9.el8 try http://www.rsyslog.com/e/2442 ]
Feb 13 18:22:38 servera systemd[1]: Started System Logging Service.
Feb 13 18:22:38 servera rsyslogd[25410]: [origin software="rsyslogd" swVersion="8.37.0-9.el8" x-pid="25410" x-info="http://www.rsyslog.com"] start
Feb 13 18:27:58 servera student[25416]: Debug Message Test
```

3.3. Exit both the root and student users' shells on servera to return to the student user's shell on workstation.
```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run lab log-configure finish to complete this exercise. This script ensures that the environment is restored back to the clean state.
```
[student@workstation ~]$ lab log-configure finish
```

This concludes the guided exercise.