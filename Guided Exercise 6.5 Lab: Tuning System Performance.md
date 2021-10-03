# Guided Exercise 6.5 Lab: Tuning System Performance

## Performance Checklist

In this lab, you will apply a specific tuning profile and adjust the scheduling priority of an existing process with high CPU usage.

## Outcomes

You should be able to:

- Activate a specific tuning profile for a computer system.

- Adjust the CPU scheduling priority of a process.

Log in as the student user on workstation using student as the password.

From workstation, run the lab tuning-review start command. The command runs a start script to determine whether the serverb host is reachable on the network.

```
[student@workstation ~]$ lab tuning-review start
```

1. Change the current tuning profile for serverb to balanced, a general non-specialized tuned profile.

1.1. From workstation, open an SSH session to serverb as student user. The systems are configured to use SSH keys for authentication, so a password is not required.

```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

1.2. Use yum to confirm that the tuned package is installed.

```
[student@serverb ~]$ yum list tuned
...output omitted...
Installed Packages
tuned.noarch                    2.10.0-15.el8                    @anaconda
```

1.3. Use the systemctl is-active tuned command to display the tuned service state.

```
[student@serverb ~]$ systemctl is-active tuned
active
```

1.4. List all available tuning profiles and their descriptions. Note that the current active profile is virtual-guest.

```
[student@serverb ~]$ sudo tuned-adm list
[sudo] password for student: student
Available profiles:
- balanced               - General non-specialized tuned profile
- desktop                - Optimize for the desktop use-case
- latency-performance    - Optimize for deterministic performance at the cost of
                           increased power consumption
- network-latency        - Optimize for deterministic performance at the cost of
                           increased power consumption, focused on low latency
                           network performance
- network-throughput     - Optimize for streaming network throughput, generally
                           only necessary on older CPUs or 40G+ networks
- powersave              - Optimize for low power consumption
- throughput-performance - Broadly applicable tuning that provides excellent
                           performance across a variety of common server workloads
- virtual-guest          - Optimize for running inside a virtual guest
- virtual-host           - Optimize for running KVM guests
Current active profile: virtual-guest
```

1.5. Change the current active tuning profile to the balanced profile.

```
[student@serverb ~]$ sudo tuned-adm profile balanced
```

1.6. List summary information of the current active tuned profile.

Use the tuned-adm profile_info command to confirm that the active profile is the balanced profile.

```
[student@serverb ~]$ sudo tuned-adm profile_info
Profile name:
balanced

Profile summary:
General non-specialized tuned profile
...output omitted...
```

2. Two processes on serverb are consuming a high percentage of CPU usage. Adjust each process's nice level to 10 to allow more CPU time for other processes.

2.1. Determine the top two CPU consumers on serverb. The top CPU consumers are listed last in the command output. CPU percentage values will vary.

```
[student@serverb ~]$ ps aux --sort=pcpu
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
...output omitted...
root      2983  100  0.0 228360  1744 ?        R<   21:08   0:23 md5sum /dev/zero
root      2967  101  0.0 228360  1732 ?        RN   21:08   0:23 sha1sum /dev/zero
[student@serverb ~]$
```

2.2. Identify the current nice level for each of the top two CPU consumers.

```
[student@serverb ~]$ ps -o pid,pcpu,nice,comm \
$(pgrep sha1sum;pgrep md5sum)
  PID %CPU  NI COMMAND
 2967 99.6   2 sha1sum
 2983 99.7  -2 md5sum
```

2.3. Use the sudo renice -n 10 2967 2983 command to adjust the nice level for each process to 10. Use PID values identified in the previous command output.

```
[student@serverb ~]$ sudo renice -n 10 2967 2983
[sudo] password for student: student
2967 (process ID) old priority 2, new priority 10
2983 (process ID) old priority -2, new priority 10
```

2.4. Verify that the current nice level for each process is 10.

```
[student@serverb ~]$ ps -o pid,pcpu,nice,comm \
$(pgrep sha1sum;pgrep md5sum)
  PID %CPU  NI COMMAND
 2967 99.6  10 sha1sum
 2983 99.7  10 md5sum
```

2.5. Exit from serverb.

```
[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$
```

## Evaluation

On workstation, run the lab tuning-review grade command to confirm success of this lab exercise.

```
[student@workstation ~]$ lab tuning-review grade
```

## Finish

On workstation, run the lab tuning-review finish script to complete this exercise.

```
[student@workstation ~]$ lab tuning-review finish
```

This concludes the lab.
