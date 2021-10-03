# Guided Exercise 6.4: Influencing Process Scheduling
In this exercise, you will adjust the scheduling priority of processes with the nice and renice commands and observe the effects this has on process execution.

## Outcomes

You should be able to adjust scheduling priorities for processes.

Log in as the student user on workstation using student as the password.

From workstation, run the lab tuning-procscheduling start command. The command runs a start script to determine if the servera host is reachable on the network.

```
[student@workstation ~]$ lab tuning-procscheduling start
```

1. From workstation use SSH to log in to servera as the student user. The systems are configured to use SSH keys for authentication, so a password is not required.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Determine the number of CPU cores on servera and then start two instances of the sha1sum /dev/zero & command for each core.

2.1. Use grep to parse the number of existing virtual processors (CPU cores) from the /proc/cpuinfo file.

```
[student@servera ~]$ grep -c '^processor' /proc/cpuinfo
2
```

2.2. Use a looping command to start multiple instances of the sha1sum /dev/zero & command. Start two per virtual processor found in the previous step. In this example, that would be four instances. The PID values in your output will vary from the example.

```
[student@servera ~]$ for i in $(seq 1 4); do sha1sum /dev/zero & done
[1] 2643
[2] 2644
[3] 2645
[4] 2646
```

3. Verify that the background jobs are running for each of the sha1sum processes.

```
[student@servera ~]$ jobs
[1]   Running                 sha1sum /dev/zero &
[2]   Running                 sha1sum /dev/zero &
[3]-  Running                 sha1sum /dev/zero &
[4]+  Running                 sha1sum /dev/zero &
```

4. Use the ps and pgrep commands to display the percentage of CPU usage for each sha1sum process.

```
[student@servera ~]$ ps u $(pgrep sha1sum)
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
student   2643 49.8  0.0 228360  1744 pts/0    R    11:15   6:09 sha1sum /dev/zero
student   2644 49.8  0.0 228360  1780 pts/0    R    11:15   6:09 sha1sum /dev/zero
student   2645 49.8  0.0 228360  1748 pts/0    R    11:15   6:09 sha1sum /dev/zero
student   2646 49.8  0.0 228360  1780 pts/0    R    11:15   6:09 sha1sum /dev/zero
```

5. Terminate all sha1sum processes, then verify that there are no running jobs.

5.1. Use the pkill command to terminate all running processes with the name pattern sha1sum.

```
[student@servera ~]$ pkill sha1sum
[2]   Terminated              sha1sum /dev/zero
[4]+  Terminated              sha1sum /dev/zero
[1]-  Terminated              sha1sum /dev/zero
[3]+  Terminated              sha1sum /dev/zero
```

5.2. Verify that there are no running jobs.

```
[student@servera ~]$ jobs
[student@servera ~]$ 
```

6. Start multiple instances of sha1sum /dev/zero &, then start one additional instance of sha1sum /dev/zero & with a nice level of 10. Start at least as many instances as the system has virtual processors. In this example, 3 regular instances are started, plus another with the higher nice level.

6.1. Use looping to start three instances of sha1sum /dev/zero &.

```
[student@servera ~]$ for i in $(seq 1 3); do sha1sum /dev/zero & done
[1] 1947
[2] 1948
[3] 1949
```

6.2. Use the nice command to start the fourth instance with a 10 nice level.

```
[student@servera ~]$ nice -n 10 sha1sum /dev/zero &
[4] 1953
```

7. Use the ps and pgrep commands to display the PID, percentage of CPU usage, nice value, and executable name for each process. The instance with the nice value of 10 should display a lower percentage of CPU usage than the other instances.

```
[student@servera ~]$ ps -o pid,pcpu,nice,comm $(pgrep sha1sum)
  PID %CPU  NI COMMAND
 1947 66.0   0 sha1sum
 1948 65.7   0 sha1sum
 1949 66.1   0 sha1sum
 1953  6.7  10 sha1sum
```

8. Use the sudo renice command to lower the nice level of a process from the previous step. Note the PID value from the process instance with the nice level of 10. Use that process PID to lower its nice level to 5.

```
[student@servera ~]$ sudo renice -n 5 1953
[sudo] password for student: student
1953 (process ID) old priority 10, new priority 5
```

9. Repeat the ps and pgrep commands to redisplay the CPU percent and nice level.

```
[student@servera ~]$ ps -o pid,pcpu,nice,comm $(pgrep sha1sum)
  PID %CPU  NI COMMAND
 1947 63.8   0 sha1sum
 1948 62.8   0 sha1sum
 1949 65.3   0 sha1sum
 1953  9.1   5 sha1sum
```

10. Use the pkill command to terminate all running processes with the name pattern sha1sum.

```
[student@servera ~]$ pkill sha1sum
...output omitted...
```

11. Exit from servera.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab tuning-procscheduling finish script to finish this exercise.

```
[student@workstation ~]$ lab tuning-procscheduling finish
```

This concludes the guided exercise.
