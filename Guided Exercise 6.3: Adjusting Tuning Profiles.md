# Guided Exercise 6.3: Adjusting Tuning Profiles

In this exercise, you will tune a server’s performance by activating the tuned service and applying a tuning profile.

## Outcomes

You should be able to configure a system to use a tuning profile.

Log in as the student user on workstation using student as the password.

From workstation, run the lab tuning-profiles start command. The command runs a start script to determine if the servera host is reachable on the network.

```
[student@workstation ~]$ lab tuning-profiles start
```

1. From workstation, use SSH to log in to servera as the student user. The systems are configured to use SSH keys for authentication, therefore a password is not required.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Verify that the tuned package is installed, enabled, and started.

2.1. Use yum to confirm that the tuned package is installed.

```
[student@servera ~]$ yum list tuned
...output omitted...
Installed Packages
tuned.noarch                    2.10.0-15.el8                    @anaconda
```

2.2. The systemctl is-enabled tuned command shows whether the service is enabled.

```
[student@servera ~]$ systemctl is-enabled tuned
enabled
```

2.3. The systemctl is-active tuned command show whether the service is currently running.

```
[student@servera ~]$ systemctl is-active tuned
active
```

3. List the available tuning profiles and identify the active profile. If sudo prompts for a password, enter student after the prompt.

```
[student@servera ~]$ sudo tuned-adm list
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

4. Change the current active tuning profile to powersave, then confirm the results. If sudo prompts for a password, enter student after the prompt.

4.1. Change the current active tuning profile.

```
[student@servera ~]$ sudo tuned-adm profile powersave
```

4.2. Confirm that powersave is the active tuning profile.

```
[student@servera ~]$ sudo tuned-adm active
Current active profile: powersave
```

5. Exit from servera.

```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$
```

## Finish

On workstation, run the lab tuning-profiles finish script to finish this exercise.

```
[student@workstation ~]$ lab tuning-profiles finish
```

This concludes the guided exercise.
