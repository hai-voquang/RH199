# Guided Exercise 6.1: Killing Processes

In this exercise, you will use signals to manage and stop processes.

## Outcomes

You should be able to start and stop multiple shell processes.

Log in to workstation as student using student as the password.

On workstation, run the lab processes-kill start command. The command runs a start script that determines whether the host, servera, is reachable on the network.

```
[student@workstation ~]$ lab processes-kill start
```

1. On workstation, open two terminal windows side by side. In this section, these terminals are referred to as left and right. In each terminal, use the ssh command to log in to servera as the student user.

```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. In the left window, create a new directory called /home/student/bin. In the new directory, create a shell script called killing. Make the script executable.

2.1. Use the mkdir command to create a new directory called /home/student/bin.

```
[student@servera ~]$ mkdir /home/student/bin
```

2.2. Use the vim command to create a script called killing in the /home/student/bin directory. Press the i key to enter Vim interactive mode. Use the :wq command to save the file.

```
[student@servera ~]$ vim /home/student/bin/killing
#!/bin/bash
while true; do
  echo -n "$@ " >> ~/killing_outfile
  sleep 5
done
```

NOTE
The killing script runs until terminated. It appends command line arguments to the ~/killing_outfile once every 5 seconds.

2.3. Use the chmod command to make the killing file executable.

```
[student@servera ~]$ chmod +x /home/student/bin/killing
In the left terminal shell, use the cd command to change into the /home/student/bin/ directory. Start three killing processes with the arguments network, interface, and connection, respectively. Start three processes called network, interface, and connection. Use the ampersand (&) to start the processes in the background.

[student@servera ~]$ cd /home/student/bin
[student@servera bin]$ killing network &
[1] 3460
[student@servera bin]$ killing interface &
[2] 3482
[student@servera bin]$ killing connection & 
[3] 3516
```

Your processes will have different PID numbers.

4. In the right terminal shell, use the tail command with the -f option to confirm that all three processes are appending to the /home/student/killing_outfile file.

```
[student@servera ~]$ tail -f ~/killing_outfile
network interface network connection interface network connection interface network
...output omitted...
```

5. In the left terminal shell, use the jobs command to list jobs.

```
[student@servera bin]$ jobs
[1]   Running                 killing network &
[2]-  Running                 killing interface &
[3]+  Running                 killing connection & 
```

6. Use signals to suspend the network process. Confirm that the network process is Stopped. In the right terminal shell, confirm that the network process is no longer appending output to the ~/killing_output.

6.1. Use the kill with the -SIGSTOP option to stop the network process. Run the jobs to confirm it is stopped.

```
[student@servera bin]$ kill -SIGSTOP %1
[1]+  Stopped                 killing network
[student@servera bin]$ jobs
[1]+  Stopped                 killing network
[2]   Running                 killing interface &
[3]-  Running                 killing connection & 
```

6.2. In the right terminal shell, look at the output from the tail command. Confirm that the word network is no longer being appended to the ~/killing_outfile file.

```
...output omitted...
interface connection interface connection interface connection interface 
```

7. In the left terminal shell, terminate the interface process using signals. Confirm that the interface process has disappeared. In the right terminal shell, confirm that interface process output is no longer appended to the ~/killing_outfile file.

7.1. Use the kill command with the -SIGTERM option to terminate the interface process. Run the jobs command to confirm that it has been terminated.

```
[student@servera bin]$ kill -SIGTERM %2
[student@servera bin]$ jobs
[1]+  Stopped                 killing network
[2]   Terminated              killing interface
[3]-  Running                 killing connection & 
```

7.2. In the right terminal shell, look at the output from the tail command. Confirm that the word interface is no longer being appended to the ~/killing_outfile file.

```
...output omitted...
connection connection connection connection connection connection connection connection 
```

8. In the left terminal shell, resume the network process using signals. Confirm that the network process is Running. In the right window, confirm that network process output is being appended to the ~/killing_outfile file.

8.1. Use the kill command with the -SIGCONT to resume the network process. Run the jobs command to confirm that the process is Running.

```
[student@servera bin]$ kill -SIGCONT %1
[student@servera bin]$ jobs
[1]+  Running                 killing network &
[3]-  Running                 killing connection & 
```

8.2. In the right terminal shell, look at the output from the tail command. Confirm that the word network is being appended to the ~/killing_outfile file.

```
...output omitted...
network connection network connection network connection network connection network connection 
```

9. In the left terminal shell, terminate the remaining two jobs. Confirm that no jobs remain and that output has stopped.

9.1. Use the kill command with the -SIGTERM option to terminate the network process. Use the same command to terminate the connection process.

```
[student@servera bin]$ kill -SIGTERM %1
[student@servera bin]$ kill -SIGTERM %3
[1]+  Terminated              killing network
[student@servera bin]$ jobs
[3]+  Terminated              killing connection 
```

10. In the left terminal shell, list tail processes running in all open terminal shells. Terminate running tail commands. Confirm that the process is no longer running.

10.1. Use the ps command with the -ef option to list all running tail processes. Refine the search using the grep command.

```
[student@servera bin]$ ps -ef | grep tail
student   4581 31358  0 10:02 pts/0    00:00:00 tail -f killing_outfile
student   4869  2252  0 10:33 pts/1    00:00:00 grep --color=auto tail
```

10.2. Use the pkill command with the -SIGTERM option to kill the tail process. Use the ps to confirm it is no longer present.

```
[student@servera bin]$ pkill -SIGTERM tail
[student@servera bin]$ ps -ef | grep tail
student   4874  2252  0 10:36 pts/1    00:00:00 grep --color=auto tail 
```

10.3. In the right terminal shell, confirm that the tail command is no longer running.

```
...output omitted...
network connection network connection network connection Terminated
[student@servera ~]$ 
```

11. Exit from both terminal windows. Failure to exit from all sessions causes the finish script to fail.

```
[student@servera bin]$ exit
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

## Finish

On workstation, run the lab processes-kill finish script to complete this exercise.

```
[student@workstation ~]$ lab processes-kill finish
```

This concludes the guided exercise.
