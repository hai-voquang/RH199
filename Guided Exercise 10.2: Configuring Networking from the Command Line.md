# Guided Exercise 10.2: Configuring Networking from the Command Line

In this exercise, you will configure network settings using nmcli.

## Outcomes

You should be able to convert a system from DHCP to static configuration.

Log in as the student user on workstation using student as the password.

From workstation, run the lab net-configure start command. The command runs a start script that determine if the host, servera, is reachable on the network.
```
[student@workstation ~]$ lab net-configure start
```

NOTE
If prompted by the sudo command for student's password, enter student as the password.

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

Locate the network interface name associated with the Ethernet address 52:54:00:00:fa:0a. Record or remember this name and use it to replace the enX placeholder in subsequent commands.
```
[student@servera ~]$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0a brd ff:ff:ff:ff:ff:ff
```
3. View network settings using nmcli.

3.1. Show all connections.
```
[student@servera ~]$ nmcli con show
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  03da038a-3257-4722-a478-53055cc90128  ethernet  enX
```

3.2. Display only the active connection.

Your network interface name should appear under DEVICE, and the name of the connection active for that device is listed on the same line under NAME. This exercise assumes that the active connection is Wired connection 1.

If the name of the active connection is different, use that instead of Wired connection 1 for the rest of this exercise.
```
[student@servera ~]$ nmcli con show --active
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  03da038a-3257-4722-a478-53055cc90128  ethernet  enX
```

3.3. Display all configuration settings for the active connection.
```
[student@servera ~]$ nmcli con show "Wired connection 1"
connection.id:               Wired connection 1
connection.uuid:             03da038a-3257-4722-a478-53055cc90128
connection.stable-id:        --
connection.type:             802-3-ethernet
connection.interface-name:   --
connection.autoconnect:      yes
...output omitted...
ipv4.method:                 manual
ipv4.dns:                    172.25.250.254
ipv4.dns-search:             lab.example.com,example.com
ipv4.dns-options:            ""
ipv4.dns-priority:           0
ipv4.addresses:              172.25.250.10/24
ipv4.gateway:                172.25.250.254
...output omitted...
GENERAL.NAME:                Wired connection 1
GENERAL.UUID:                03da038a-3257-4722-a478-53055cc90128
GENERAL.DEVICES:             enX
GENERAL.STATE:               activated
GENERAL.DEFAULT:             yes
GENERAL.DEFAULT6:            no
GENERAL.SPEC-OBJECT:         --
GENERAL.VPN:                 no
GENERAL.DBUS-PATH:           /org/freedesktop/NetworkManager/ActiveConnection/1
GENERAL.CON-PATH:            /org/freedesktop/NetworkManager/Settings/1
GENERAL.ZONE:                --
GENERAL.MASTER-PATH:         --
IP4.ADDRESS[1]:              172.25.250.10/24
IP4.GATEWAY:                 172.25.250.254
IP4.ROUTE[1]:                dst = 172.25.250.0/24, nh = 0.0.0.0, mt = 100
IP4.ROUTE[2]:                dst = 0.0.0.0/0, nh = 172.25.250.254, mt = 100
IP4.DNS[1]:                  172.25.250.254
IP6.ADDRESS[1]:              fe80::3059:5462:198:58b2/64
IP6.GATEWAY:                 --
IP6.ROUTE[1]:                dst = fe80::/64, nh = ::, mt = 100
IP6.ROUTE[2]:                dst = ff00::/8, nh = ::, mt = 256, table=255
```
Press q to exit the command.

3.4. Show device status.
```
[student@servera ~]$ nmcli dev status
DEVICE  TYPE      STATE      CONNECTION
enX     ethernet  connected  Wired connection 1
lo      loopback  unmanaged  --
```

3.5. Display the settings for the enX device.
```
[student@servera ~]$ nmcli dev show enX
GENERAL.DEVICE:              enX
GENERAL.TYPE:                ethernet
GENERAL.HWADDR:              52:54:00:00:FA:0A
GENERAL.MTU:                 1500
GENERAL.STATE:               100 (connected)
GENERAL.CONNECTION:          Wired connection 1
GENERAL.CON-PATH:            /org/freedesktop/NetworkManager/ActiveConnection/1
WIRED-PROPERTIES.CARRIER:    on
IP4.ADDRESS[1]:              172.25.250.10/24
IP4.GATEWAY:                 172.25.250.254
IP4.ROUTE[1]:                dst = 172.25.250.0/24, nh = 0.0.0.0, mt = 100
IP4.ROUTE[2]:                dst = 0.0.0.0/0, nh = 172.25.250.254, mt = 100
IP4.DNS[1]:                  172.25.250.254
IP6.ADDRESS[1]:              fe80::3059:5462:198:58b2/64
IP6.GATEWAY:                 --
IP6.ROUTE[1]:                dst = fe80::/64, nh = ::, mt = 100
IP6.ROUTE[2]:                dst = ff00::/8, nh = ::, mt = 256, table=255
```

4. Create a static connection with the same IPv4 address, network prefix, and default gateway. Name the new connection static-addr.

WARNING
Since access to your machine is provided over the primary network connection, setting incorrect values during network configuration may make your machine unreachable. If this happens, use the Reset button located above what used to be your machine's graphical display and try again.
```
[student@servera ~]$ sudo nmcli con add con-name "static-addr" ifname enX \
type ethernet ipv4.method manual \
ipv4.address 172.25.250.10/24 ipv4.gateway 172.25.250.254
Connection 'static-addr' (15aa3901-555d-40cb-94c6-cea6f9151634) successfully added.
```

5. Modify the new connection to add the DNS setting.
```
[student@servera ~]$ sudo nmcli con mod "static-addr" ipv4.dns 172.25.250.254
```

6. Display and activate the new connection.

6.1. View all connections.
```
[student@servera ~]$ nmcli con show
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  03da038a-3257-4722-a478-53055cc90128  ethernet  enX
static-addr         15aa3901-555d-40cb-94c6-cea6f9151634  ethernet  --
```

6.2. View the active connection.
```
[student@servera ~]$ nmcli con show --active
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  03da038a-3257-4722-a478-53055cc90128  ethernet  enX
```

6.3. Activate the new static-addr connection.
```
[student@servera ~]$ sudo nmcli con up "static-addr"
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/2)
```

6.4. Verify the new active connection.
```
[student@servera ~]$ nmcli con show --active
NAME         UUID                                  TYPE      DEVICE
static-addr  15aa3901-555d-40cb-94c6-cea6f9151634  ethernet  enX
```

7. Configure the original connection so that it does not start at boot, and verify that the static connection is used when the system reboots.

7.1. Disable the original connection from autostarting at boot.
```
[student@servera ~]$ sudo nmcli con mod "Wired connection 1" \
connection.autoconnect no
```

7.2. Reboot the system.
```
[student@servera ~]$ sudo systemctl reboot
Connection to servera closed by remote host.
Connection to servera closed.
[student@workstation ~]$
```

7.3. View the active connection.
```
[student@workstation ~]$ ssh student@servera
...output omitted...
[student@servera ~]$ nmcli con show --active
NAME         UUID                                  TYPE      DEVICE
static-addr  15aa3901-555d-40cb-94c6-cea6f9151634  ethernet  enX
```

8. Test connectivity using the new network addresses.

8.1. Verify the IP address.
```
[student@servera ~]$ ip addr show enX
2: enX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:00:fa:0a brd ff:ff:ff:ff:ff:ff
    inet 172.25.250.10/24 brd 172.25.250.255 scope global noprefixroute enX
       valid_lft forever preferred_lft forever
    inet6 fe80::6556:cdd9:ce15:1484/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

8.2. Verify the default gateway.
```
[student@servera ~]$ ip route
default via 172.25.250.254 dev enX proto static metric 100
172.25.250.0/24 dev enX proto kernel scope link src 172.25.250.10 metric 100
```

8.3. Ping the DNS address.
```
[student@servera ~]$ ping -c3 172.25.250.254
PING 172.25.250.254 (172.25.250.254) 56(84) bytes of data.
64 bytes from 172.25.250.254: icmp_seq=1 ttl=64 time=0.225 ms
64 bytes from 172.25.250.254: icmp_seq=2 ttl=64 time=0.314 ms
64 bytes from 172.25.250.254: icmp_seq=3 ttl=64 time=0.472 ms

--- 172.25.250.254 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 46ms
rtt min/avg/max/mdev = 0.225/0.337/0.472/0.102 ms
```

8.4. Exit from servera.
```
[student@servera ~]$ exit
logout
Connection to servera closed.
[student@workstation ~]$ 
```

## Finish

On workstation, run the lab net-configure finish script to finish this exercise.
```
[student@workstation ~]$ lab net-configure finish
```

This concludes the guided exercise.

