# Guided Exercise 10.3: Editing Network Configuration Files

In this exercise, you will manually modify network configuration files and ensure that the new settings take effect.

## Outcomes

You should be able to add an additional network address to each system.

Log in as the student user on workstation using student as the password.

From workstation, run the lab net-edit start command. The command runs a start script that determine if the hosts, servera and serverb, are reachable on the network.
```
[student@workstation ~]$ lab net-edit start
```

1. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication, so a password is not required to log in to servera.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. Locate network interface names.

IMPORTANT
Network interface names are determined by their bus type and the detection order of devices during boot. Your network interface names will vary according to the course platform and hardware in use.

On your system now, locate the interface name (such as ens06 or en1p2) associated with the Ethernet address 52:54:00:00:fa:0a. Use this interface name to replace the enX placeholder used throughout this exercise.

Locate the network interface name associated with the Ethernet address 52:54:00:00:fa:0a. Record or remember this name and use it to replace the enX placeholder in subsequent commands. The active connection is also named Wired connection 1 (and therefore is managed by the file /etc/sysconfig/network-scripts/ifcfg-Wired_connection_1).

If you have done previous exercises in this chapter and this was true for your system, it should be true for this exercise as well.
```
[student@servera ~]$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0a brd ff:ff:ff:ff:ff:ff
[student@servera ~]$ nmcli con show --active
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  03da038a-3257-4722-a478-53055cc90128  ethernet  enX
[student@servera ~]$ ls \
/etc/sysconfig/network-scripts/ifcfg-Wired_connection_1
/etc/sysconfig/network-scripts/ifcfg-Wired_connection_1
```

3. On servera, switch to the root user, and then edit the /etc/sysconfig/network-scripts/ifcfg-Wired_connection_1 file to add an additional address of 10.0.1.1/24.

3.1. Use the sudo -i command to switch to the root user. The password for the student user is student.
```
[student@servera ~]$ sudo -i
[sudo] password for student: student
[root@servera ~]# 
```

3.2. Append an entry to the file to specify the IPv4 address.
```
[root@servera ~]# echo \
"IPADDR1=10.0.1.1" >> /etc/sysconfig/network-scripts/ifcfg-Wired_connection_1
```

3.3. Append an entry to the file to specify the network prefix.
```
[root@servera ~]# echo \
"PREFIX1=24" >> /etc/sysconfig/network-scripts/ifcfg-Wired_connection_1
```

4. Activate the new address.

4.1. Reload the configuration changes.
```
[root@servera ~]# nmcli con reload
```

4.2. Restart the connection with the new settings.
```
[root@servera ~]# nmcli con up "Wired connection 1"
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/3)
```

5. Verify the new IP address.
```
[root@servera ~]# ip addr show enX
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0a brd ff:ff:ff:ff:ff:ff
    inet 172.25.250.10/24 brd 172.25.250.255 scope global noprefixroute enX
       valid_lft forever preferred_lft forever
    inet 10.0.1.1/24 brd 10.0.1.255 scope global noprefixroute enX
       valid_lft forever preferred_lft forever
    inet6 fe80::4bf3:e1d9:3076:f8d7/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

6. Exit from servera to return to workstation as the student user.
```
[root@servera ~]# exit
logout
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

7. On serverb, edit the /etc/sysconfig/network-scripts/ifcfg-Wired_connection_1 file to add an additional address of 10.0.1.2/24, then load the new configuration.

7.1. From workstation, use the ssh command to log in to serverb as the student user.
```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

7.2. Use the sudo -i command to switch to the root user. The password for the student user is student.
```
[student@serverb ~]$ sudo -i
[sudo] password for student: student
[root@serverb ~]# 
```

7.3. Modify the ifcfg-Wired_connection_1 file to add the second IPv4 address and network prefix.
```
[root@serverb ~]# echo \
"IPADDR1=10.0.1.2" >> /etc/sysconfig/network-scripts/ifcfg-Wired_connection_1
[root@serverb ~]# echo \
"PREFIX1=24" >> /etc/sysconfig/network-scripts/ifcfg-Wired_connection_1
```

7.4. Reload the configuration changes.
```
[root@serverb ~]# nmcli con reload
```

7.5. Bring up the connection with the new settings.
```
[root@serverb ~]# nmcli con up "Wired connection 1"
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/4)
```

7.6. Verify the new IP address.
```
[root@serverb ~]# ip addr show enX
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0b brd ff:ff:ff:ff:ff:ff
    inet 172.25.250.11/24 brd 172.25.250.255 scope global noprefixroute enX
       valid_lft forever preferred_lft forever
    inet 10.0.1.2/24 brd 10.0.1.255 scope global noprefixroute enX
       valid_lft forever preferred_lft forever
    inet6 fe80::74c:3476:4113:463f/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

8. Test connectivity using the new network addresses.

8.1. From serverb, ping the new address of servera.
```
[root@serverb ~]# ping -c3 10.0.1.1
PING 10.0.1.1 (10.0.1.1) 56(84) bytes of data.
64 bytes from 10.0.1.1: icmp_seq=1 ttl=64 time=0.342 ms
64 bytes from 10.0.1.1: icmp_seq=2 ttl=64 time=0.188 ms
64 bytes from 10.0.1.1: icmp_seq=3 ttl=64 time=0.317 ms

--- 10.0.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 35ms
rtt min/avg/max/mdev = 0.188/0.282/0.342/0.068 ms
```

8.2. Exit from serverb to return to workstation.
```
[root@serverb ~]# exit
logout
[student@serverb ~]$ exit
logout
Connection to serverb closed.
[student@workstation ~]$ 
```

8.3. From workstation, use the ssh command to access servera as the student user to ping the new address of serverb.
```
[student@workstation ~]$ ssh student@servera ping -c3 10.0.1.2
PING 10.0.1.2 (10.0.1.2) 56(84) bytes of data.
64 bytes from 10.0.1.2: icmp_seq=1 ttl=64 time=0.269 ms
64 bytes from 10.0.1.2: icmp_seq=2 ttl=64 time=0.338 ms
64 bytes from 10.0.1.2: icmp_seq=3 ttl=64 time=0.361 ms

--- 10.0.1.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 48ms
rtt min/avg/max/mdev = 0.269/0.322/0.361/0.044 ms
```

## Finish

On workstation, run the lab net-edit finish script to finish this exercise.
```
[student@workstation ~]$ lab net-edit finish
```

This concludes the guided exercise.

