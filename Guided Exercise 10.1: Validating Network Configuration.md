# Guided Exercise 10.1: Validating Network Configuration

In this exercise, you will inspect the network configuration of one of your servers.

## Outcomes

Identify the current network interfaces and basic network addresses.

Log in as the student user on workstation using student as the password.

From workstation, run the lab net-validate start command. The command runs a start script that determine if the host, servera, is reachable on the network.
```
[student@workstation ~]$ lab net-validate start
```
1. Use the ssh command to log in to servera as the student user. The systems are configured to use SSH keys for authentication and passwordless access to servera.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ 
```

2. IMPORTANT
Network interface names are determined by their bus type and the detection order of devices during boot. Your network interface names will vary according to the course platform and hardware in use.

On your system now, locate the interface name (such as ens06 or en1p2) associated with the Ethernet address 52:54:00:00:fa:0a. Use this interface name to replace the enX placeholder used throughout this exercise.

Locate the network interface name associated with the Ethernet address 52:54:00:00:fa:0a. Record or remember this name and use it to replace the enX placeholder in subsequent commands.
```
[student@servera ~]$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0a brd ff:ff:ff:ff:ff:ff
```
3. Display the current IP address and netmask for all interfaces.
```
[student@servera ~]$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0a brd ff:ff:ff:ff:ff:ff
    inet 172.25.250.10/24 brd 172.25.250.255 scope global noprefixroute ens3
       valid_lft forever preferred_lft forever
    inet6 fe80::3059:5462:198:58b2/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```
4. Display the statistics for the enX interface.
```
[student@servera ~]$ ip -s link show enX
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:00:fa:0a brd ff:ff:ff:ff:ff:ff
    RX: bytes  packets  errors  dropped overrun mcast   
    89014225   168251   0       154418  0       0       
    TX: bytes  packets  errors  dropped carrier collsns 
    608808     6090     0       0       0       0
```
5. Display the routing information.
```
[student@servera ~]$ ip route
default via 172.25.250.254 dev enX proto static metric 100
172.25.250.0/24 dev enX proto kernel scope link src 172.25.250.10 metric 100
```
6. Verify that the router is accessible.
```
[student@servera ~]$ ping -c3 172.25.250.254
PING 172.25.250.254 (172.25.250.254) 56(84) bytes of data.
64 bytes from 172.25.250.254: icmp_seq=1 ttl=64 time=0.196 ms
64 bytes from 172.25.250.254: icmp_seq=2 ttl=64 time=0.436 ms
64 bytes from 172.25.250.254: icmp_seq=3 ttl=64 time=0.361 ms

--- 172.25.250.254 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 49ms
rtt min/avg/max/mdev = 0.196/0.331/0.436/0.100 ms
```
7. Show all the hops between the local system and classroom.example.com.
```
[student@servera ~]$ tracepath classroom.example.com
 1?: [LOCALHOST]                      pmtu 1500
 1:  workstation.lab.example.com                           0.270ms 
 1:  workstation.lab.example.com                           0.167ms 
 2:  classroom.example.com                                 0.473ms reached
     Resume: pmtu 1500 hops 2 back 2
```
8. Display the listening TCP sockets on the local system.
```
[student@servera ~]$ ss -lt
State      Recv-Q Send-Q      Local Address:Port         Peer Address:Port
LISTEN     0      128               0.0.0.0:sunrpc            0.0.0.0:*   
LISTEN     0      128               0.0.0.0:ssh               0.0.0.0:*   
LISTEN     0      128                  [::]:sunrpc               [::]:*   
LISTEN     0      128                  [::]:ssh                  [::]:*   
```
9. Exit from servera.
```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$
```

## Finish

On workstation, run the lab net-validate finish script to finish this exercise.
```
[student@workstation ~]$ lab net-validate finish
```

This concludes the guided exercise.