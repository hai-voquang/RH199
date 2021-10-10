# Guided Exercise 11.3: Preserving the System Journal

In this exercise, you will configure the system journal to preserve its data after a reboot.

## Outcomes

You should be able to configure the system journal to preserve its data after a reboot.

Log in to workstation as student using student as the password.

On workstation, run lab log-preserve start to start the exercise. This script ensures that the environment is set up correctly.
```
[student@workstation ~]$ lab log-preserve start
```

1. From workstation, open an SSH session to servera as student.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. As the superuser, confirm that the /var/log/journal directory does not exist. Use the ls command to list the /var/log/journal directory contents. Use sudo to elevate the student user privileges. Use student as the password if asked.
```
[student@servera ~]$ sudo ls /var/log/journal
[sudo] password for student: student
ls: cannot access '/var/log/journal': No such file or directory
```

As the /var/log/journal directory does not exist, the systemd-journald service is not preserving its log data.

3. Configure the systemd-journald service on servera to preserve journals across a reboot.

3.1. Uncomment the Storage=auto line in the /etc/systemd/journald.conf file and set Storage to persistent. You may use the sudo vim /etc/systemd/journald.conf command to edit the configuration file. Type / Storage=auto from vim command mode to search for the Storage=auto line.
```
...output omitted...
[Journal]
Storage=persistent
...output omitted...
```

3.2. Use the systemctl command to restart the systemd-journald service to bring the configuration changes into effect.
```
[student@servera ~]$ sudo systemctl restart systemd-journald.service
```

4. Confirm that the systemd-journald service on servera preserves its journals such that the journals persist across reboots.

4.1. Use the systemctl reboot command to restart servera.
```
[student@servera ~]$ sudo systemctl reboot
Connection to servera closed by remote host.
Connection to servera closed.
[student@workstation ~]$ 
```

Notice that the SSH connection was terminated as soon as you restarted the servera system.

4.2. Open an SSH session to servera again.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

4.3. Use the ls command to confirm that the /var/log/journal directory exists. The /var/log/journal directory contains a subdirectory with a long hexadecimal name. The journal files are found in that directory. The subdirectory name on your system will be different.
```
[student@servera ~]$ sudo ls /var/log/journal
[sudo] password for student: student
73ab164e278e48be9bf80e80714a8cd5
[student@servera ~]$ sudo ls \
/var/log/journal/73ab164e278e48be9bf80e80714a8cd5
system.journal  user-1000.journal
```

4.4. Log out of servera.
```
[student@servera ~]$ exit
logout
Connection to servera closed.
```

## Finish

On workstation, run lab log-preserve finish to complete this exercise. This script ensures that the environment is restored back to the clean state.
```
[student@workstation ~]$ lab log-preserve finish
```

This concludes the guided exercise.