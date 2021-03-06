# Guided Exercise 10.5 Lab: Managing Networking

## Performance Checklist

In this lab, you will configure networking settings on a Red Hat Enterprise Linux server.

## Outcomes

You should be able to configure two static IPv4 addresses for the primary network interface.

Log in as the student user on workstation using student as the password.

From workstation run the lab net-review start command. The command runs a start script that determine if the host, serverb, is reachable on the network.
```
[student@workstation ~]$ lab net-review start
```

1. Use the ssh command to log in to serverb as the student user. The systems are configured to use SSH keys for authentication, so a password is not required to log in to serverb.
```
[student@workstation ~]$ ssh student@serverb
...output omitted...
[student@serverb ~]$ 
```

2. Use the sudo -i command to switch to the root user. If prompted, use student as the password.
```
[student@serverb ~]$ sudo -i
[sudo] password for student: student
[root@serverb ~]# 
```

3. Create a new connection with a static network connection using the settings in the table.

|Parameter	|Setting |
|-----------|------- |
|Connection name |	lab|
|Interface name	|enX (might vary, use the interface that has 52:54:00:00:fa:0b as its MAC address) |
|IP address	|172.25.250.11/24 |
|Gateway address |	172.25.250.254|
|DNS address |172.25.250.254 |

Determine the interface name and the current active connection's name. The solution assumes that the interface name is enX and the connection name is Wired connection 1.
```
[root@serverb ~]# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0b brd ff:ff:ff:ff:ff:ff
[root@serverb ~]# nmcli con show --active
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  03da038a-3257-4722-a478-53055cc90128  ethernet  enX
```

Create the new lab connection profile based on the information in the table described in the instructions. Associate the profile with your network interface name listed in the output of the previous ip link command.
```
[root@serverb ~]# nmcli con add con-name lab ifname enX type ethernet \
ipv4.method manual \
ipv4.address 172.25.250.11/24 ipv4.gateway 172.25.250.254
[root@serverb ~]# nmcli con mod "lab" ipv4.dns 172.25.250.254
```

4. Configure the new connection to be autostarted. Other connections should not start automatically.
```
[root@serverb ~]# nmcli con mod "lab" connection.autoconnect yes
[root@serverb ~]# nmcli con mod "Wired connection 1" connection.autoconnect no
```

5. Modify the new connection so that it also uses the address 10.0.1.1/24.
```
[root@serverb ~]# nmcli con mod "lab" +ipv4.addresses 10.0.1.1/24
```
Or alternately:
```
[root@serverb ~]# echo "IPADDR1=10.0.1.1" \
>> /etc/sysconfig/network-scripts/ifcfg-lab
[root@serverb ~]# echo "PREFIX1=24" >> /etc/sysconfig/network-scripts/ifcfg-lab
```

6. Configure the hosts file so that 10.0.1.1 can be referenced as private.
```
[root@serverb ~]# echo "10.0.1.1 private" >> /etc/hosts
```

7. Reboot the system.
```
[root@serverb ~]# systemctl reboot
Connection to serverb closed by remote host.
Connection to serverb closed.
[student@workstation ~]$ 
```

8. From workstation use the ping command to verify that serverb is initialized.
```
[student@workstation ~]$ ping -c3 serverb
PING serverb.lab.example.com (172.25.250.11) 56(84) bytes of data.
64 bytes from serverb.lab.example.com (172.25.250.11): icmp_seq=1 ttl=64 time=0.478 ms
64 bytes from serverb.lab.example.com (172.25.250.11): icmp_seq=2 ttl=64 time=0.504 ms
64 bytes from serverb.lab.example.com (172.25.250.11): icmp_seq=3 ttl=64 time=0.513 ms

--- serverb.lab.example.com ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 78ms
rtt min/avg/max/mdev = 0.478/0.498/0.513/0.023 ms
[student@workstation ~]$ 
```

## Evaluation

On workstation, run the lab net-review grade script to confirm success on this lab.
```
[student@workstation ~]$ lab net-review grade
```

## Finish

On workstation, run the lab net-review finish script to finish this lab.
```
[student@workstation ~]$ lab net-review finish
```

This concludes the lab.
