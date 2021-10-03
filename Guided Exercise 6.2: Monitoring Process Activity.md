# Guided Exercise 6.2: Monitoring Process Activity

In this exercise, you will use the top command to dynamically examine running processes and control them.

## Outcomes

You should be able to manage processes in real time.

Log in to workstation as student using student as the password.

On workstation, run the lab processes-monitor start command. The command runs a start script that determines if the host, servera, is reachable on the network.

```
[student@workstation ~]$ lab processes-monitor start
```

1. On workstation open two terminal windows side by side. These terminals are referred to as left and right. On each terminal, use the ssh command to log in to servera as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. In the left terminal shell, create a new directory called /home/student/bin. In the new directory create a shell script called monitor, which generates artificial CPU load. Ensure the script is executable.

2.1. Use the mkdir command to create a new directory called /home/student/bin.

```
[student@servera ~]$ mkdir /home/student/bin
```

2.2. Create a script named monitor in the /home/student/bin directory with the following content:

```
#!/bin/bash
while true; do
  var=1
  while [[ var -lt 60000 ]]; do
    var=$(($var+1))
  done
  sleep 1
done
```

The monitor script runs until terminated. It generates artificial CPU load by performing sixty thousand addition problems. It then sleeps for one second, resets the variable, and repeats.

2.3. Use the chmod command to make the monitor file executable.

```
[student@servera ~]$ chmod a+x /home/student/bin/monitor
```

3. In the right terminal shell, run the top utility. Size the window to be as tall as possible.

```
[student@servera ~]$ top
top - 12:13:03 up 11 days, 58 min,  3 users,  load average: 0.00, 0.00, 0.00
Tasks: 113 total,   2 running, 111 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.2 us,  0.0 sy,  0.0 ni, 99.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :   1829.4 total,   1377.3 free,    193.9 used,    258.2 buff/cache
MiB Swap:   1024.0 total,   1024.0 free,      0.0 used.   1476.1 avail Mem

PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
5861 root      20   0       0      0      0 I   0.3   0.0   0:00.71 kworker/1:3-events
6068 student   20   0  273564   4300   3688 R   0.3   0.2   0:00.01 top
   1 root      20   0  178680  13424   8924 S   0.0   0.7   0:04.03 systemd
   2 root      20   0       0      0      0 S   0.0   0.0   0:00.03 kthreadd
   3 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 rcu_gp
...output omitted...
```

4. In the left terminal shell use the lscpu command to determine the number of logical CPUs on this virtual machine.

```
[student@servera ~]$ lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              2
...output omitted...
```

5. In the left terminal shell, run a single instance of the monitor executable. Use the ampersand (&) to run the process in the background.

```
[student@servera ~]$ monitor &
[1] 6071  
```

6. In the right terminal shell, observe the top display. Use the single keystrokes l, t, and m to toggle the load, threads, and memory header lines. After observing this behavior, ensure that all headers are displaying.

7. Note the process ID (PID) for monitor. View the CPU percentage for the process, which is expected to hover around 15% to 25%.

```
[student@servera ~]$ top
PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
071 student   20   0  222448   2964   2716 S  18.7   0.2   0:27.35 monitor
...output omitted...
```

View the load averages. The one minute load average is currently less than a value of 1. The value observed may be affected by resource contention from another virtual machine or the virtual host.

```
top - 12:23:45 up 11 days,  1:09,  3 users,  load average: 0.21, 0.14, 0.05
```

8. In the left terminal shell, run a second instance of monitor. Use the ampersand (&) to run the process in the background.

```
[student@servera ~]$ monitor &
[2] 6498  
```

9. In the right terminal shell, note the process ID (PID) for the second monitor process. View the CPU percentage for the process, also expected to hover between 15% and 25%.

```
[student@servera ~]$ top
 PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
6071 student   20   0  222448   2964   2716 S  19.0   0.2   1:36.53 monitor
6498 student   20   0  222448   2996   2748 R  15.7   0.2   0:16.34 monitor
...output omitted...
```

View the one minute load average again, which is still less than 1. It is important to wait for at least one minute to allow the calculation to adjust to the new workload.

```
top - 12:27:39 up 11 days,  1:13,  3 users,  load average: 0.36, 0.25, 0.11 
```

10. In the left terminal shell, run a third instance of monitor. Use the ampersand (&) to run the process in the background.

```
[student@servera ~]$ monitor &
[3] 6881 
```

11. In the right terminal shell, note the process ID (PID) for the third monitor process. View the CPU percentage for the process, again expected to hover between 15% and 25%.

```
[student@servera ~]$ top
 PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
6881 student   20   0  222448   3032   2784 S  18.6   0.2   0:11.48 monitor
6498 student   20   0  222448   2996   2748 S  15.6   0.2   0:47.86 monitor
6071 student   20   0  222448   2964   2716 S  18.1   0.2   2:07.86 monitor 
```

To push the load average above 1, you must start more monitor processes. The classroom setup has 2 CPUs so only 3 processes are not enough to stress it. Start three more monitor processes. View the one minute load average again, which now is expected to be above 1. It is important to wait for at least one minute to allow the calculation to adjust to the new workload.

```
[student@servera ~]$ monitor &
[4] 10708
[student@servera ~]$ monitor &
[5] 11122
[student@servera ~]$ monitor &
[6] 11338
```
```
top - 12:42:32 up 11 days,  1:28,  3 users,  load average: 1.23, 2.50, 1.54
```

12. When finished observing the load average values, terminate each of the monitor processes from within top.

12.1. In the right terminal shell, press k. Observe the prompt below the headers and above the columns.

```
...output omitted...
PID to signal/kill [default pid = 11338] 
```

12.2. The prompt has chosen the monitor processes at the top of the list. Press Enter to kill the process.

```
...output omitted...
Send pid 11338 signal [15/sigterm] 
```

12.3. Press Enter again to confirm the SIGTERM signal 15.

Confirm that the selected process is no longer observed in top. If the PID still remains, repeat these terminating steps, substituting SIGKILL signal 9 when prompted.

```
 6498 student   20   0  222448   2996   2748 R  22.9   0.2   5:31.47 monitor
 6881 student   20   0  222448   3032   2784 R  21.3   0.2   4:54.47 monitor
11122 student   20   0  222448   2984   2736 R  15.3   0.2   2:32.48 monitor
 6071 student   20   0  222448   2964   2716 S  15.0   0.2   6:50.90 monitor
10708 student   20   0  222448   3032   2784 S  14.6   0.2   2:53.46 monitor
```

13. Repeat the previous step for each remaining monitor instance. Confirm that no monitor processes remain in top.

14. In the right terminal shell, press q to exit top. Exit from servera on both terminal windows.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```
```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

# Finish

On workstation, run the lab processes-monitor finish script to complete this exercise.

```
[student@workstation ~]$ lab processes-monitor finish
```

This concludes the guided exercise.
